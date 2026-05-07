#!/usr/bin/env zsh

CCO_GLM_MODEL="${CCO_GLM_MODEL:-glm-5.1:cloud}"
CCO_KIMI_MODEL="${CCO_KIMI_MODEL:-kimi-k2.6:cloud}"
CCO_DEEPSEEK_MODEL="${CCO_DEEPSEEK_MODEL:-deepseek-v4-pro:cloud}"
CCO_DEEPSEEK_FLASH_MODEL="${CCO_DEEPSEEK_FLASH_MODEL:-deepseek-v4-flash:cloud}"
CCO_DEFAULT_MODEL="${CCO_DEFAULT_MODEL:-glm}"
CCO_GLM_CONTEXT_WINDOW="${CCO_GLM_CONTEXT_WINDOW:-202752}"
CCO_KIMI_CONTEXT_WINDOW="${CCO_KIMI_CONTEXT_WINDOW:-262144}"
CCO_DEEPSEEK_CONTEXT_WINDOW="${CCO_DEEPSEEK_CONTEXT_WINDOW:-1048576}"

_cco_resolve_model() {
  local model_type="$1"
  case "$model_type" in
    glm|glm-5.1)              echo "$CCO_GLM_MODEL" ;;
    kimi|kimi-k2.6)           echo "$CCO_KIMI_MODEL" ;;
    deepseek|ds|deepseek-pro) echo "$CCO_DEEPSEEK_MODEL" ;;
    *)                        echo "__UNKNOWN__" ;;
  esac
}

_cco_resolve_flash_model() {
  local model_type="$1"
  case "$model_type" in
    deepseek|ds|deepseek-pro) echo "$CCO_DEEPSEEK_FLASH_MODEL" ;;
    *)                        echo "$(_cco_resolve_model "$model_type")" ;;
  esac
}

_cco_resolve_context_window() {
  local model_type="$1"
  case "$model_type" in
    glm|glm-5.1)              echo "$CCO_GLM_CONTEXT_WINDOW" ;;
    kimi|kimi-k2.6)           echo "$CCO_KIMI_CONTEXT_WINDOW" ;;
    deepseek|ds|deepseek-pro) echo "$CCO_DEEPSEEK_CONTEXT_WINDOW" ;;
    *)                        echo "" ;;
  esac
}

_cco_show_status() {
  cat <<EOF

  cco — Ollama Claude Code Launcher
  ==================================

  Ollama endpoint:  http://localhost:11434
  Default model:   $CCO_DEFAULT_MODEL

  Model mapping:
    glm          → $CCO_GLM_MODEL
    kimi         → $CCO_KIMI_MODEL
    deepseek     → $CCO_DEEPSEEK_MODEL
    deepseek-flash (haiku/subagent) → $CCO_DEEPSEEK_FLASH_MODEL

  Context windows:
    glm          → $CCO_GLM_CONTEXT_WINDOW
    kimi         → $CCO_KIMI_CONTEXT_WINDOW
    deepseek     → $CCO_DEEPSEEK_CONTEXT_WINDOW

  Shortcuts:
    ccg  → cco --model glm
    cck  → cco --model kimi
    ccd  → cco --model deepseek

  Override defaults with env vars:
    CCO_GLM_MODEL, CCO_KIMI_MODEL, CCO_DEEPSEEK_MODEL, CCO_DEFAULT_MODEL
    CCO_GLM_CONTEXT_WINDOW, CCO_KIMI_CONTEXT_WINDOW, CCO_DEEPSEEK_CONTEXT_WINDOW

EOF
}

_cco_show_help() {
  cat <<'EOF'
cco — Claude Code with Ollama Cloud Backend

Usage: cco [options] [-- claude-args...]

Options:
  -m, --model <glm|kimi|deepseek>  Model type (default: glm)
  --status                          Show model mapping & config
  -h, --help                        Show this help

Shortcuts:
  ccg  → cco --model glm
  cck  → cco --model kimi
  ccd  → cco --model deepseek

Environment variables:
  CCO_GLM_MODEL                 Override glm model name (default: glm-5.1:cloud)
  CCO_KIMI_MODEL                Override kimi model name (default: kimi-k2.6:cloud)
  CCO_DEEPSEEK_MODEL            Override deepseek model name (default: deepseek-v4-pro:cloud)
  CCO_DEEPSEEK_FLASH_MODEL      Override deepseek haiku/subagent model (default: deepseek-v4-flash:cloud)
  CCO_DEFAULT_MODEL             Default model type (default: glm)
  CCO_GLM_CONTEXT_WINDOW        Override glm context window (default: 202752)
  CCO_KIMI_CONTEXT_WINDOW       Override kimi context window (default: 262144)
  CCO_DEEPSEEK_CONTEXT_WINDOW   Override deepseek context window (default: 1048576)
EOF
}

cco() {
  local model_type="$CCO_DEFAULT_MODEL"
  local action="launch"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --model|-m) model_type="$2"; shift 2 ;;
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
    echo "       Use: glm, kimi, deepseek" >&2
    return 1
  fi

  local haiku_model="$model_name"
  local subagent_model="$model_name"
  local compact_window
  compact_window="$(_cco_resolve_context_window "$model_type")"
  if [[ "$model_type" == (deepseek|ds|deepseek-pro) ]]; then
    haiku_model="$CCO_DEEPSEEK_FLASH_MODEL"
    subagent_model="$CCO_DEEPSEEK_FLASH_MODEL"
  fi

  echo "  Launching Claude Code with $model_name..."

  local env_vars=(
    "CLAUDE_CONFIG_DIR=$HOME/.claude-local"
    "CLAUDE_CODE_PLUGIN_CACHE_DIR=$HOME/.claude-local/plugins"
    "ANTHROPIC_BASE_URL=http://localhost:11434"
    "ANTHROPIC_API_KEY="
    "ANTHROPIC_AUTH_TOKEN=ollama"
    "ANTHROPIC_MODEL=$model_name"
    "ANTHROPIC_DEFAULT_OPUS_MODEL=$model_name"
    "ANTHROPIC_DEFAULT_SONNET_MODEL=$model_name"
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

ccg() { cco --model glm "$@"; }
cck() { cco --model kimi "$@"; }
ccd() { cco --model deepseek "$@"; }
