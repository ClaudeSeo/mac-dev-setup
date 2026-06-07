#!/usr/bin/env zsh
set -euo pipefail

readonly LOCK_DIR="/tmp/cmux-sync.lock"
readonly VIEW_SESSION_PREFIX="cmux-sync-view-"

exec {LOG_FD}>&1

_log() {
  print -r -- "[$(date '+%Y-%m-%d %H:%M:%S')] [$1] $2" >&$LOG_FD
}

_log_stderr() {
  local level="$1" line
  while IFS= read -r line || [[ -n "$line" ]]; do
    _log "$level" "$line"
  done
}

_cmux_safe() {
  "$@" 2> >(_log_stderr "WARN") || {
    local ec=$?
    _log "WARN" "cmux command failed (exit $ec): $*"
    return $ec
  }
}

_tmux_attach_command() {
  print -r -- "tmux attach -t ${(q)1}"
}

_tmux_view_session_name() {
  print -r -- "${VIEW_SESSION_PREFIX}${1}__${2#%}"
}

_ensure_tmux_view_session() {
  local session="$1" window_pane="$2" pane_id="$3"
  local view_session="$(_tmux_view_session_name "$session" "$pane_id")"
  if ! tmux has-session -t "$view_session" 2>/dev/null; then
    tmux new-session -d -t "$session" -s "$view_session" 2> >(_log_stderr "WARN") || return 1
  fi
  tmux select-window -t "$view_session:${window_pane%%.*}" 2> >(_log_stderr "WARN") || true
  tmux select-pane -t "$view_session:$window_pane" 2> >(_log_stderr "WARN") || true
  print -r -- "$view_session"
}

_pane_title() {
  local window_pane="$1" pane_id="$2" path="$3"
  local dir_name="${path:t}"
  [[ -z "$dir_name" ]] && dir_name="$path"
  print -r -- "$window_pane $dir_name"
}

_contains() {
  local needle="$1" item
  shift
  for item in "$@"; do [[ "$item" == "$needle" ]] && return 0; done
  return 1
}

typeset -A workspace_surface_by_pane_key
typeset -A workspace_surface_kind_by_pane_key
typeset -A workspace_surface_tty_by_surface
workspace_managed_keys=()
workspace_first_pane=""
workspace_first_surface=""

_collect_workspace_surfaces() {
  local workspace="$1"
  local pane_line pane_ref surface_line surface_ref surface_name surface_kind resume_json tree_line tty_name
  workspace_surface_by_pane_key=()
  workspace_surface_kind_by_pane_key=()
  workspace_surface_tty_by_surface=()
  workspace_managed_keys=()
  workspace_first_pane=""
  workspace_first_surface=""

  while IFS= read -r tree_line; do
    [[ "$tree_line" =~ 'surface:[0-9]+' ]] || continue
    surface_ref="$MATCH"
    [[ "$tree_line" =~ 'tty=[^ ]+' ]] || continue
    tty_name="${MATCH#tty=}"
    workspace_surface_tty_by_surface[$surface_ref]="/dev/$tty_name"
  done < <(_cmux_safe cmux tree --workspace "$workspace" || true)

  while IFS= read -r pane_line; do
    [[ "$pane_line" =~ 'pane:[0-9]+' ]] || continue
    pane_ref="$MATCH"
    [[ -z "$workspace_first_pane" ]] && workspace_first_pane="$pane_ref"
    while IFS= read -r surface_line; do
      [[ "$surface_line" =~ 'surface:[0-9]+' ]] || continue
      surface_ref="$MATCH"
      [[ -z "$workspace_first_surface" ]] && workspace_first_surface="$surface_ref"
      resume_json="$(_cmux_safe cmux surface resume show --json --workspace "$workspace" --surface "$surface_ref" || true)"
      surface_name="$(print -r -- "$resume_json" | jq -r 'select(.resume_binding.kind == "cmux-tmux-view" or .resume_binding.kind == "cmux-tmux-pane") | .resume_binding.checkpoint_id // empty' || true)"
      surface_kind="$(print -r -- "$resume_json" | jq -r '.resume_binding.kind // empty' || true)"
      if [[ -z "$surface_name" && "$surface_line" =~ 'tmux-pane:[^ ]+' ]]; then
        surface_name="$MATCH"
      fi
      [[ -n "$surface_name" ]] || continue
      workspace_surface_by_pane_key[$surface_name]="$surface_ref"
      workspace_surface_kind_by_pane_key[$surface_name]="$surface_kind"
      workspace_managed_keys+=("$surface_name")
    done < <(_cmux_safe cmux list-pane-surfaces --workspace "$workspace" --pane "$pane_ref" || true)
  done < <(_cmux_safe cmux list-panes --workspace "$workspace" || true)
}

_sync_surface_to_view_session() {
  local workspace_id="$1" surface_id="$2" view_session="$3" command="$4" source_session="$5"
  local client_tty="${workspace_surface_tty_by_surface[$surface_id]-}"
  local client_name client_session
  if [[ -n "$client_tty" ]]; then
    while IFS=$'\t' read -r client_name client_session; do
      [[ "$client_name" == "$client_tty" ]] || continue
      if [[ "$client_session" == "$view_session" ]]; then
        return 0
      fi
      if [[ "$client_session" == "$source_session" || "$client_session" == ${VIEW_SESSION_PREFIX}${source_session}__* ]]; then
        tmux switch-client -c "$client_tty" -t "$view_session" 2> >(_log_stderr "WARN") || true
        return 0
      fi
      break
    done < <(tmux list-clients -F "#{client_name}"$'\t'"#{session_name}" 2>/dev/null || true)
  fi
  _cmux_safe cmux respawn-pane --workspace "$workspace_id" --surface "$surface_id" --command "$command" || true
}

_selected_surface_for_pane() {
  local workspace_id="$1" pane_id="$2"
  local surface_line
  while IFS= read -r surface_line; do
    [[ "$surface_line" == \** ]] || continue
    [[ "$surface_line" =~ 'surface:[0-9]+' ]] || continue
    print -r -- "$MATCH"
    return 0
  done < <(_cmux_safe cmux list-pane-surfaces --workspace "$workspace_id" --pane "$pane_id" || true)
}

_wait_surface_tty() {
  local workspace_id="$1" surface_id="$2"
  local tree_line tty_name attempt
  for attempt in {1..50}; do
    while IFS= read -r tree_line; do
      [[ "$tree_line" == *"$surface_id "* ]] || continue
      [[ "$tree_line" =~ 'tty=[^ ]+' ]] || continue
      tty_name="${MATCH#tty=}"
      print -r -- "/dev/$tty_name"
      return 0
    done < <(_cmux_safe cmux tree --workspace "$workspace_id" || true)
    sleep 0.1
  done
  return 1
}

_start_command_on_new_surface() {
  local workspace_id="$1" pane_id="$2" surface_id="$3" command="$4"
  local previous_surface start_status
  previous_surface="$(_selected_surface_for_pane "$workspace_id" "$pane_id")"
  start_status=0

  # cmux terminal surface는 focus 후 tty가 생긴 뒤에 command 입력이 가능하다.
  _cmux_safe cmux focus-panel --workspace "$workspace_id" --panel "$surface_id" || start_status=1
  if [[ $start_status -eq 0 ]]; then
    _wait_surface_tty "$workspace_id" "$surface_id" >/dev/null || start_status=1
  fi
  if [[ $start_status -eq 0 ]]; then
    _cmux_safe cmux send --workspace "$workspace_id" --surface "$surface_id" "$command" || start_status=1
  fi
  if [[ $start_status -eq 0 ]]; then
    _cmux_safe cmux send-key --workspace "$workspace_id" --surface "$surface_id" Enter || start_status=1
  fi

  if [[ -n "$previous_surface" && "$previous_surface" != "$surface_id" ]]; then
    _cmux_safe cmux focus-panel --workspace "$workspace_id" --panel "$previous_surface" || true
  fi

  return $start_status
}

# Atomic lock via mkdir: macOS-native, no external dependency
# stale lock 회수: lock은 디렉터리이므로 안에 PID를 기록하고,
#   해당 PID가 죽은 프로세스면 비정상 종료가 남긴 stale lock으로 보고 회수
readonly LOCK_PID_FILE="$LOCK_DIR/pid"
if ! mkdir "$LOCK_DIR" 2>/dev/null; then
  owner_pid=""
  [[ -f "$LOCK_PID_FILE" ]] && owner_pid="$(<"$LOCK_PID_FILE")"
  if [[ -n "$owner_pid" ]] && kill -0 "$owner_pid" 2>/dev/null; then
    _log "INFO" "Another instance running (pid $owner_pid) — skipping"
    exit 0
  fi
  _log "WARN" "Reclaiming stale lock (owner pid ${owner_pid:-unknown} not alive)"
  rm -rf "$LOCK_DIR" 2>/dev/null
  mkdir "$LOCK_DIR" 2>/dev/null || { _log "INFO" "Lost lock race — skipping"; exit 0; }
fi
echo "$$" > "$LOCK_PID_FILE"
trap '_log "ERROR" "failed at line $LINENO (exit $?)"' ERR
trap 'rm -rf "$LOCK_DIR" 2>/dev/null' EXIT INT TERM

# Pre-flight checks
command -v tmux >/dev/null 2>&1 || { _log "INFO" "tmux not found — exiting"; exit 0; }
command -v cmux >/dev/null 2>&1 || { _log "INFO" "cmux not found — exiting"; exit 0; }
command -v jq >/dev/null 2>&1 || { _log "INFO" "jq not found — exiting"; exit 0; }

# cmux daemon connectivity check
_cmux_safe cmux workspace list > /dev/null 2>&1 || {
  _log "INFO" "cmux daemon not responding — exiting"
  exit 0
}

# Collect tmux sessions
tmux_sessions=()
while IFS= read -r session; do
  [[ "$session" == ${VIEW_SESSION_PREFIX}* ]] && continue
  tmux_sessions+=("$session")
done < <(tmux list-sessions -F "#{session_name}" 2> >(_log_stderr "WARN") || true)

_log "INFO" "Found ${#tmux_sessions[@]} tmux session(s): ${tmux_sessions[*]}"

typeset -A tmux_pane_keys_by_session
typeset -A tmux_pane_title_by_key
typeset -A tmux_pane_target_by_key
typeset -A tmux_pane_view_by_key
tmux_pane_format="#{session_name}"$'\t'"#{window_index}.#{pane_index}"$'\t'"#{pane_id}"$'\t'"#{pane_current_path}"
while IFS=$'\t' read -r session window_pane pane_id pane_path; do
  [[ "$session" == ${VIEW_SESSION_PREFIX}* ]] && continue
  [[ -z "$session" || -z "$pane_id" ]] && continue
  pane_key="tmux-pane:$session:$pane_id"
  view_session="$(_ensure_tmux_view_session "$session" "$window_pane" "$pane_id" || true)"
  [[ -n "$view_session" ]] || continue
  tmux_pane_keys_by_session[$session]+="${pane_key}"$'\n'
  tmux_pane_title_by_key[$pane_key]="$(_pane_title "$window_pane" "$pane_id" "$pane_path")"
  tmux_pane_target_by_key[$pane_key]="$view_session"
  tmux_pane_view_by_key[$pane_key]="$view_session"
done < <(tmux list-panes -a -F "$tmux_pane_format" 2> >(_log_stderr "WARN") || true)

# Collect cmux workspaces with tmux: prefix
# cmux workspace list 출력 형식: [*] workspace:N  name  [selected]
# name에서 tmux: prefix 추출, id는 workspace close 용으로 저장
typeset -A cmux_id_map  # name → workspace ID
cmux_names=()

while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  [[ "$line" =~ 'tmux:[^ ]+' ]] || continue
  name="$MATCH"
  [[ "$line" =~ 'workspace:[0-9]+' ]] || continue
  id="$MATCH"
  cmux_id_map[$name]="$id"
  cmux_names+=("$name")
done < <(_cmux_safe cmux workspace list || true)

# Phase 1: Delete orphan cmux workspaces (tmux: prefix, no matching tmux session)
for name in "${cmux_names[@]}"; do
  session_name="${name#tmux:}"
  found=0
  for s in "${tmux_sessions[@]}"; do
    if [[ "$s" == "$session_name" ]]; then
      found=1
      break
    fi
  done
  if [[ $found -eq 0 ]]; then
    _log "INFO" "Deleting orphan workspace: $name (${cmux_id_map[$name]})"
    _cmux_safe cmux workspace close "${cmux_id_map[$name]}" || true
  fi
done

# Phase 2: Create missing cmux workspaces (tmux session without cmux workspace)
for session in "${tmux_sessions[@]}"; do
  found=0
  for name in "${cmux_names[@]}"; do
    if [[ "${name#tmux:}" == "$session" ]]; then
      found=1
      break
    fi
  done
  if [[ $found -eq 0 ]]; then
    pane_keys=(${(@f)${tmux_pane_keys_by_session[$session]-}})
    command="tmux attach -t ${(q)session}"
    if [[ ${#pane_keys[@]} -gt 0 ]]; then
      command="$(_tmux_attach_command "${tmux_pane_target_by_key[$pane_keys[1]]}")"
    fi
    _log "INFO" "Creating workspace for tmux session: $session"
    workspace_out="$(_cmux_safe cmux workspace create --name "tmux:$session" --command "$command" || true)"
    if [[ "$workspace_out" =~ 'workspace:[0-9]+' ]]; then
      cmux_id_map["tmux:$session"]="$MATCH"
      cmux_names+=("tmux:$session")
    fi
  fi
done

for session in "${tmux_sessions[@]}"; do
  workspace_id="${cmux_id_map[tmux:$session]-}"
  [[ -z "$workspace_id" ]] && continue

  pane_keys=(${(@f)${tmux_pane_keys_by_session[$session]-}})
  [[ ${#pane_keys[@]} -eq 0 ]] && continue

  _collect_workspace_surfaces "$workspace_id"
  reuse_surface=""
  if [[ ${#workspace_managed_keys[@]} -eq 0 && -n "$workspace_first_surface" ]]; then
    reuse_surface="$workspace_first_surface"
  fi

  for pane_key in "${pane_keys[@]}"; do
    command="$(_tmux_attach_command "${tmux_pane_target_by_key[$pane_key]}")"
    if [[ -n "${workspace_surface_by_pane_key[$pane_key]-}" ]]; then
      surface_id="${workspace_surface_by_pane_key[$pane_key]}"
      _sync_surface_to_view_session "$workspace_id" "$surface_id" "${tmux_pane_view_by_key[$pane_key]}" "$command" "$session"
      _cmux_safe cmux surface resume set --workspace "$workspace_id" --surface "$surface_id" --kind cmux-tmux-view --checkpoint "$pane_key" --name "${tmux_pane_title_by_key[$pane_key]}" --shell "$command" || true
      _cmux_safe cmux rename-tab --workspace "$workspace_id" --surface "$surface_id" --title "${tmux_pane_title_by_key[$pane_key]}" || true
      continue
    fi

    if [[ -n "$reuse_surface" ]]; then
      _log "INFO" "Reusing $reuse_surface for $pane_key in $workspace_id"
      _sync_surface_to_view_session "$workspace_id" "$reuse_surface" "${tmux_pane_view_by_key[$pane_key]}" "$command" "$session"
      _cmux_safe cmux surface resume set --workspace "$workspace_id" --surface "$reuse_surface" --kind cmux-tmux-view --checkpoint "$pane_key" --name "${tmux_pane_title_by_key[$pane_key]}" --shell "$command" || true
      _cmux_safe cmux rename-tab --workspace "$workspace_id" --surface "$reuse_surface" --title "${tmux_pane_title_by_key[$pane_key]}" || true
      workspace_surface_by_pane_key[$pane_key]="$reuse_surface"
      workspace_managed_keys+=("$pane_key")
      reuse_surface=""
      continue
    fi

    [[ -n "$workspace_first_pane" ]] || { _log "WARN" "No cmux pane found in $workspace_id"; continue; }
    _log "INFO" "Creating cmux tab for $pane_key in $workspace_id"
    pane_out="$(_cmux_safe cmux new-surface --workspace "$workspace_id" --pane "$workspace_first_pane" --type terminal --focus false || true)"
    [[ "$pane_out" =~ 'surface:[0-9]+' ]] || { _log "WARN" "new-surface did not return a surface: $pane_out"; continue; }
    surface_id="$MATCH"
    _start_command_on_new_surface "$workspace_id" "$workspace_first_pane" "$surface_id" "$command" || {
      _log "WARN" "Failed to start tmux view on $surface_id"
      _cmux_safe cmux close-surface --workspace "$workspace_id" --surface "$surface_id" || true
      continue
    }
    _cmux_safe cmux surface resume set --workspace "$workspace_id" --surface "$surface_id" --kind cmux-tmux-view --checkpoint "$pane_key" --name "${tmux_pane_title_by_key[$pane_key]}" --shell "$command" || true
    _cmux_safe cmux rename-tab --workspace "$workspace_id" --surface "$surface_id" --title "${tmux_pane_title_by_key[$pane_key]}" || true
    workspace_surface_by_pane_key[$pane_key]="$surface_id"
  done

  for pane_key in "${workspace_managed_keys[@]}"; do
    _contains "$pane_key" "${pane_keys[@]}" && continue
    _log "INFO" "Closing orphan cmux pane surface for $pane_key (${workspace_surface_by_pane_key[$pane_key]})"
    _cmux_safe cmux close-surface --workspace "$workspace_id" --surface "${workspace_surface_by_pane_key[$pane_key]}" || true
  done
done

_log "INFO" "Sync complete"
