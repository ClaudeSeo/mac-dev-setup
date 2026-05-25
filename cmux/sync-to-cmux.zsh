#!/usr/bin/env zsh
set -euo pipefail

readonly LOCK_DIR="/tmp/cmux-sync.lock"
readonly LOG_FILE="$HOME/Library/Logs/cmux-sync.log"

_log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$1] $2" >> "$LOG_FILE"
}

_cmux_safe() {
  "$@" 2>>"$LOG_FILE" || {
    local ec=$?
    _log "WARN" "cmux command failed (exit $ec): $*"
    return $ec
  }
}

# Atomic lock via mkdir: macOS-native, no external dependency
# stale file이 lock path에 남아있는 경우 자동 정리
if [[ -f "$LOCK_DIR" ]]; then
  rm -f "$LOCK_DIR" 2>/dev/null
fi
mkdir "$LOCK_DIR" 2>/dev/null || {
  _log "INFO" "Another instance running ($LOCK_DIR exists) — skipping"
  exit 0
}
trap '_log "ERROR" "failed at line $LINENO (exit $?)"' ERR
trap 'rmdir "$LOCK_DIR" 2>/dev/null' EXIT INT TERM

# Pre-flight checks
command -v tmux >/dev/null 2>&1 || { _log "INFO" "tmux not found — exiting"; exit 0; }
command -v cmux >/dev/null 2>&1 || { _log "INFO" "cmux not found — exiting"; exit 0; }

# cmux daemon connectivity check
_cmux_safe cmux list-workspaces > /dev/null 2>&1 || {
  _log "INFO" "cmux daemon not responding — exiting"
  exit 0
}

# Collect tmux sessions
tmux_sessions=()
while IFS= read -r session; do
  tmux_sessions+=("$session")
done < <(tmux list-sessions -F "#{session_name}" 2>>"$LOG_FILE" || true)

_log "INFO" "Found ${#tmux_sessions[@]} tmux session(s): ${tmux_sessions[*]}"

# Collect cmux workspaces with tmux: prefix
# cmux list-workspaces 출력 형식: [*] workspace:N  name  [selected]
# name에서 tmux: prefix 추출, id는 close-workspace 용으로 저장
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
done < <(_cmux_safe cmux list-workspaces 2>>"$LOG_FILE" || true)

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
    _cmux_safe cmux close-workspace --workspace "${cmux_id_map[$name]}" || true
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
    _log "INFO" "Creating workspace for tmux session: $session"
    _cmux_safe cmux new-workspace --name "tmux:$session" --command "tmux attach -t $session" || true
  fi
done

_log "INFO" "Sync complete"
