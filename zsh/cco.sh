#!/usr/bin/env zsh

CCO_GLM_MODEL="${CCO_GLM_MODEL:-glm-5.1:cloud}"
CCO_KIMI_MODEL="${CCO_KIMI_MODEL:-kimi-k2.6:cloud}"
CCO_DEEPSEEK_MODEL="${CCO_DEEPSEEK_MODEL:-deepseek-v4-pro:cloud}"
CCO_DEEPSEEK_FLASH_MODEL="${CCO_DEEPSEEK_FLASH_MODEL:-deepseek-v4-flash:cloud}"
CCO_CONFIG_FILE="${CCO_CONFIG_FILE:-$HOME/.config/cco/config}"
CCO_GLM_CONTEXT_WINDOW="${CCO_GLM_CONTEXT_WINDOW:-202752}"
CCO_KIMI_CONTEXT_WINDOW="${CCO_KIMI_CONTEXT_WINDOW:-262144}"
CCO_DEEPSEEK_CONTEXT_WINDOW="${CCO_DEEPSEEK_CONTEXT_WINDOW:-1048576}"

_cco_load_config() {
  [[ -f "$CCO_CONFIG_FILE" ]] || return 0

  local line key value
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" == \#* || "$line" != *=* ]] && continue
    key="${line%%=*}"
    value="${line#*=}"

    case "$key" in
      default) CCO_CONFIG_DEFAULT_MODEL="$value" ;;
      opus)    CCO_CONFIG_OPUS_MODEL="$value" ;;
      sonnet)  CCO_CONFIG_SONNET_MODEL="$value" ;;
      haiku)   CCO_CONFIG_HAIKU_MODEL="$value" ;;
    esac
  done < "$CCO_CONFIG_FILE"
}

_cco_load_config

CCO_DEFAULT_MODEL="${CCO_DEFAULT_MODEL:-${CCO_CONFIG_DEFAULT_MODEL:-$CCO_GLM_MODEL}}"
CCO_OPUS_MODEL="${CCO_OPUS_MODEL:-${CCO_CONFIG_OPUS_MODEL:-$CCO_KIMI_MODEL}}"
CCO_SONNET_MODEL="${CCO_SONNET_MODEL:-${CCO_CONFIG_SONNET_MODEL:-$CCO_GLM_MODEL}}"
CCO_HAIKU_MODEL="${CCO_HAIKU_MODEL:-${CCO_CONFIG_HAIKU_MODEL:-$CCO_DEEPSEEK_FLASH_MODEL}}"

_cco_canonical_model_value() {
  local model_value="$1"

  if [[ "$model_value" == "glm" || "$model_value" == "glm-5.1" || "$model_value" == "$CCO_GLM_MODEL" ]]; then
    echo "$CCO_GLM_MODEL"
    return
  fi

  if [[ "$model_value" == "kimi" || "$model_value" == "kimi-k2.6" || "$model_value" == "$CCO_KIMI_MODEL" ]]; then
    echo "$CCO_KIMI_MODEL"
    return
  fi

  if [[ "$model_value" == "deepseek" || "$model_value" == "ds" || "$model_value" == "deepseek-pro" || "$model_value" == "$CCO_DEEPSEEK_MODEL" ]]; then
    echo "$CCO_DEEPSEEK_MODEL"
    return
  fi

  if [[ "$model_value" == "deepseek-flash" || "$model_value" == "ds-flash" || "$model_value" == "flash" || "$model_value" == "$CCO_DEEPSEEK_FLASH_MODEL" ]]; then
    echo "$CCO_DEEPSEEK_FLASH_MODEL"
    return
  fi

  echo "$model_value"
}

CCO_OPUS_MODEL="$(_cco_canonical_model_value "$CCO_OPUS_MODEL")"
CCO_SONNET_MODEL="$(_cco_canonical_model_value "$CCO_SONNET_MODEL")"
CCO_HAIKU_MODEL="$(_cco_canonical_model_value "$CCO_HAIKU_MODEL")"

_cco_canonical_config_value() {
  local model_value="$1"

  case "$model_value" in
    opus)   echo "$CCO_OPUS_MODEL" ;;
    sonnet) echo "$CCO_SONNET_MODEL" ;;
    haiku)  echo "$CCO_HAIKU_MODEL" ;;
    *)      _cco_canonical_model_value "$model_value" ;;
  esac
}

CCO_DEFAULT_MODEL="$(_cco_canonical_config_value "$CCO_DEFAULT_MODEL")"

_cco_resolve_model() {
  local model_type="$1"
  local depth="${2:-0}"
  if (( depth > 5 )); then
    echo "__UNKNOWN__"
    return
  fi

  case "$model_type" in
    opus)                              _cco_resolve_model "$CCO_OPUS_MODEL" $((depth + 1)) ;;
    sonnet)                            _cco_resolve_model "$CCO_SONNET_MODEL" $((depth + 1)) ;;
    haiku)                             _cco_resolve_model "$CCO_HAIKU_MODEL" $((depth + 1)) ;;
    glm|glm-5.1)                       echo "$CCO_GLM_MODEL" ;;
    kimi|kimi-k2.6)                    echo "$CCO_KIMI_MODEL" ;;
    deepseek|ds|deepseek-pro)          echo "$CCO_DEEPSEEK_MODEL" ;;
    deepseek-flash|ds-flash|flash)     echo "$CCO_DEEPSEEK_FLASH_MODEL" ;;
    *)                                 echo "$model_type" ;;
  esac
}

_cco_resolve_flash_model() {
  _cco_resolve_model haiku
}

_cco_resolve_context_window() {
  local model_type="$1"
  local depth="${2:-0}"
  local model_name
  if (( depth > 5 )); then
    echo ""
    return
  fi

  case "$model_type" in
    opus)                          _cco_resolve_context_window "$CCO_OPUS_MODEL" $((depth + 1)) ;;
    sonnet)                        _cco_resolve_context_window "$CCO_SONNET_MODEL" $((depth + 1)) ;;
    haiku)                         _cco_resolve_context_window "$CCO_HAIKU_MODEL" $((depth + 1)) ;;
    *)
      model_name="$(_cco_canonical_model_value "$model_type")"
      if [[ "$model_name" == "$CCO_GLM_MODEL" ]]; then
        echo "$CCO_GLM_CONTEXT_WINDOW"
      elif [[ "$model_name" == "$CCO_KIMI_MODEL" ]]; then
        echo "$CCO_KIMI_CONTEXT_WINDOW"
      elif [[ "$model_name" == "$CCO_DEEPSEEK_MODEL" || "$model_name" == "$CCO_DEEPSEEK_FLASH_MODEL" ]]; then
        echo "$CCO_DEEPSEEK_CONTEXT_WINDOW"
      else
        echo ""
      fi
      ;;
  esac
}

_cco_show_status() {
  local default_name launch_model opus_name sonnet_name haiku_name
  default_name="$(_cco_resolve_model "$CCO_DEFAULT_MODEL")"
  if [[ "$CCO_DEFAULT_MODEL" == "$default_name" ]]; then
    launch_model="$default_name"
  else
    launch_model="$CCO_DEFAULT_MODEL → $default_name"
  fi
  opus_name="$(_cco_resolve_model opus)"
  sonnet_name="$(_cco_resolve_model sonnet)"
  haiku_name="$(_cco_resolve_model haiku)"

  cat <<EOF

  cco — Ollama Claude Code Launcher
  ==================================

  Ollama endpoint:  http://localhost:11434
  Config file:      $CCO_CONFIG_FILE
  Launch model:     $launch_model

  Claude defaults:
    opus         → $opus_name
    sonnet       → $sonnet_name
    haiku        → $haiku_name

  Available models:
    $CCO_KIMI_MODEL
    $CCO_GLM_MODEL
    $CCO_DEEPSEEK_MODEL
    $CCO_DEEPSEEK_FLASH_MODEL

  Context windows:
    $CCO_GLM_MODEL → $CCO_GLM_CONTEXT_WINDOW
    $CCO_KIMI_MODEL → $CCO_KIMI_CONTEXT_WINDOW
    $CCO_DEEPSEEK_MODEL → $CCO_DEEPSEEK_CONTEXT_WINDOW
    $CCO_DEEPSEEK_FLASH_MODEL → $CCO_DEEPSEEK_CONTEXT_WINDOW

  Config commands:
    cco config set default glm-5.1:cloud
    cco config set opus kimi-k2.6:cloud
    cco config set sonnet glm-5.1:cloud
    cco config set haiku deepseek-v4-flash:cloud

  Override defaults with env vars:
    CCO_DEFAULT_MODEL, CCO_OPUS_MODEL, CCO_SONNET_MODEL, CCO_HAIKU_MODEL
    CCO_GLM_MODEL, CCO_KIMI_MODEL, CCO_DEEPSEEK_MODEL, CCO_DEEPSEEK_FLASH_MODEL
    CCO_GLM_CONTEXT_WINDOW, CCO_KIMI_CONTEXT_WINDOW, CCO_DEEPSEEK_CONTEXT_WINDOW

EOF
}

_cco_show_help() {
  cat <<'EOF'
cco — Claude Code with Ollama Cloud Backend

Usage: cco [options] [-- claude-args...]
       cco config set <default|opus|sonnet|haiku> <model>

Options:
  -m, --model <role|model>  Launch model role or full model name
  --status                   Show model mapping & config
  -h, --help                 Show this help

Config:
  cco config set default glm-5.1:cloud
  cco config set opus kimi-k2.6:cloud
  cco config set sonnet glm-5.1:cloud
  cco config set haiku deepseek-v4-flash:cloud

Environment variables:
  CCO_CONFIG_FILE                Config file path (default: ~/.config/cco/config)
  CCO_DEFAULT_MODEL              Launch model (default: glm-5.1:cloud)
  CCO_OPUS_MODEL                 Opus default model (default: kimi-k2.6:cloud)
  CCO_SONNET_MODEL               Sonnet default model (default: glm-5.1:cloud)
  CCO_HAIKU_MODEL                Haiku/subagent default model (default: deepseek-v4-flash:cloud)
  CCO_GLM_MODEL                 Override glm model name (default: glm-5.1:cloud)
  CCO_KIMI_MODEL                Override kimi model name (default: kimi-k2.6:cloud)
  CCO_DEEPSEEK_MODEL            Override deepseek model name (default: deepseek-v4-pro:cloud)
  CCO_DEEPSEEK_FLASH_MODEL      Override deepseek flash model (default: deepseek-v4-flash:cloud)
  CCO_GLM_CONTEXT_WINDOW        Override glm context window (default: 202752)
  CCO_KIMI_CONTEXT_WINDOW       Override kimi context window (default: 262144)
  CCO_DEEPSEEK_CONTEXT_WINDOW   Override deepseek context window (default: 1048576)
EOF
}

_cco_save_config() {
  mkdir -p "${CCO_CONFIG_FILE:h}" || return 1
  {
    print -r -- "default=$CCO_DEFAULT_MODEL"
    print -r -- "opus=$CCO_OPUS_MODEL"
    print -r -- "sonnet=$CCO_SONNET_MODEL"
    print -r -- "haiku=$CCO_HAIKU_MODEL"
  } >| "$CCO_CONFIG_FILE"
}

_cco_set_config() {
  local key="$1"
  local value="$2"

  if [[ -z "$key" || -z "$value" ]]; then
    echo "Usage: cco config set <default|opus|sonnet|haiku> <model>" >&2
    return 1
  fi

  case "$key:$value" in
    opus:opus|sonnet:sonnet|haiku:haiku)
      echo "ERROR: '$key' cannot point to itself." >&2
      return 1
      ;;
  esac

  value="$(_cco_canonical_config_value "$value")"

  case "$key" in
    default|model) CCO_DEFAULT_MODEL="$value" ;;
    opus)          CCO_OPUS_MODEL="$value" ;;
    sonnet)        CCO_SONNET_MODEL="$value" ;;
    haiku)         CCO_HAIKU_MODEL="$value" ;;
    *)
      echo "ERROR: Unknown config key '$key'." >&2
      echo "       Use: default, opus, sonnet, haiku" >&2
      return 1
      ;;
  esac

  _cco_save_config || return 1
  echo "Saved cco config: $key=$value"
}

cco() {
  local model_type="$CCO_DEFAULT_MODEL"
  local action="launch"

  if [[ "$1" == "config" ]]; then
    shift
    case "$1" in
      set) _cco_set_config "$2" "$3" ;;
      status|"") _cco_show_status ;;
      *) echo "Usage: cco config set <default|opus|sonnet|haiku> <model>" >&2; return 1 ;;
    esac
    return $?
  fi

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --model|-m)
        if [[ -z "$2" ]]; then
          echo "ERROR: Missing value for $1." >&2
          return 1
        fi
        model_type="$2"
        shift 2
        ;;
      --status)   action="status"; shift ;;
      --help|-h)  action="help"; shift ;;
      --)         shift; break ;;
      *)          break ;;
    esac
  done

  if [[ "$action" == "status" ]]; then
    _cco_show_status
    return 0
  fi

  if [[ "$action" == "help" ]]; then
    _cco_show_help
    return 0
  fi

  local model_name
  model_name="$(_cco_resolve_model "$model_type")"

  if [[ "$model_name" == "__UNKNOWN__" ]]; then
    echo "ERROR: Unknown model type '$model_type'." >&2
    echo "       Use a role, alias, or raw Ollama model name." >&2
    return 1
  fi

  local haiku_model
  local opus_model
  local sonnet_model
  local subagent_model
  local compact_window
  compact_window="$(_cco_resolve_context_window "$model_type")"
  opus_model="$(_cco_resolve_model opus)"
  sonnet_model="$(_cco_resolve_model sonnet)"
  haiku_model="$(_cco_resolve_model haiku)"
  subagent_model="$haiku_model"

  echo "  Launching Claude Code with $model_name..."
  echo "  Defaults: opus=$opus_model sonnet=$sonnet_model haiku=$haiku_model"

  local env_vars=(
    "CLAUDE_CONFIG_DIR=$HOME/.claude-local"
    "CLAUDE_CODE_PLUGIN_CACHE_DIR=$HOME/.claude-local/plugins"
    "ANTHROPIC_BASE_URL=http://localhost:11434"
    "ANTHROPIC_API_KEY="
    "ANTHROPIC_AUTH_TOKEN=ollama"
    "ANTHROPIC_MODEL=$model_name"
    "ANTHROPIC_DEFAULT_OPUS_MODEL=$opus_model"
    "ANTHROPIC_DEFAULT_SONNET_MODEL=$sonnet_model"
    "ANTHROPIC_DEFAULT_HAIKU_MODEL=$haiku_model"
    "CLAUDE_CODE_SUBAGENT_MODEL=$subagent_model"
    "CLAUDE_CODE_ATTRIBUTION_HEADER=0"
    "ENABLE_TOOL_SEARCH=false"
  )
  if [[ -n "$compact_window" ]]; then
    env_vars+=(
      "CLAUDE_CODE_AUTO_COMPACT_WINDOW=$compact_window"
      "CLAUDE_CODE_MAX_CONTEXT_TOKENS=$compact_window"
      "DISABLE_COMPACT=1"
    )
  fi

  env "${env_vars[@]}" claude --model "$model_name" --dangerously-skip-permissions "$@"
}
