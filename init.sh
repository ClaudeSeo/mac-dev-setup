#!/usr/bin/env bash
set -euo pipefail

# --- Color Definitions (Premium Palette) ---
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# --- Icons (Nerd Font compatible) ---
CHECK="✔"
CROSS="✖"
ARROW="➜"
STAR="★"

# 로그 출력 함수
log() {
    echo -e "${CYAN}[$(date '+%H:%M:%S')]${NC} ${ARROW} $1"
}

success() {
    echo -e "${GREEN}${CHECK} $1${NC}"
}

error() {
    echo -e "${RED}${CROSS} $1${NC}"
}

# 현재 디렉토리 저장
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Header ---
print_header() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "   __  __            _____              _____      _               "
    echo "  |  \/  |          |  __ \            / ____|    | |              "
    echo "  | \  / | __ _  ___| |  | | _____   _| (___   ___| |_ _   _ _ __  "
    echo "  | |\/| |/ _\` |/ __| |  | |/ _ \ \ / /\___ \ / _ \ __| | | | '_ \ "
    echo "  | |  | | (_| | (__| |__| |  __/\ V / ____) |  __/ |_| |_| | |_) |"
    echo "  |_|  |_|\__,_|\___|_____/ \___| \_/ |_____/ \___|\__|\__,_| .__/ "
    echo "                                                            | |    "
    echo "                                                            |_|    "
    echo -e "${NC}"
    echo -e "${WHITE}${BOLD}             macOS Development Environment Setup${NC}"
    echo -e "${BLUE}      ──────────────────────────────────────────────────────────${NC}"
    echo ""
}

# 백업 함수
backup_file() {
    local target="$1"
    if [ -f "$target" ] && [ ! -L "$target" ]; then
        local backup
        backup="$target.backup.$(date +%Y%m%d%H%M%S)"
        log "Backing up $target to $backup"
        mv "$target" "$backup"
    fi
}

# --- 설정 함수들 ---

setup_homebrew() {
    log "Setting up Homebrew..."
    local had_error=0
    set +e
    if ! command -v brew &> /dev/null; then
        log "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || had_error=1
        if [[ $(uname -m) == 'arm64' ]]; then
            # SC2016: We want literal string here for .zshrc
            local brew_env='eval "$(/opt/homebrew/bin/brew shellenv)"'
            eval "$brew_env"
            if ! grep -q "brew shellenv" "$HOME/.zshrc" 2>/dev/null; then
                echo "$brew_env" >> "$HOME/.zshrc"
                log "Added Homebrew to PATH in ~/.zshrc"
            fi
        fi
    else
        log "Homebrew already installed. Updating..."
        brew update &> /dev/null || error "Brew update failed, continuing..."
    fi

    if [ -f "$SCRIPT_DIR/brew/Brewfile" ]; then
        log "Installing packages from Brewfile..."
        if ! (cd "$SCRIPT_DIR/brew" && brew bundle); then
            error "Some packages failed to install."
            had_error=1
        fi
    fi
    set -e
    if [ "$had_error" -eq 0 ]; then
        success "Homebrew setup complete!"
    else
        error "Homebrew setup finished with errors. Review the log above."
    fi
}

setup_neovim() {
    log "Configuring Neovim..."
    if ! command -v nvim &> /dev/null; then
        error "nvim not found. Skipping Neovim setup. (Select Homebrew first, or install nvim manually.)"
        return 0
    fi
    NVIM_DIR="$HOME/.config/nvim"
    mkdir -p "$NVIM_DIR"
    backup_file "$NVIM_DIR/init.vim"
    ln -sf "$SCRIPT_DIR/nvim/init.vim" "$NVIM_DIR/init.vim"
    curl -sfLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    nvim +PlugInstall +PlugUpdate +qa
    # init.sh에서 있던 CoC 자동 설치 복구
    nvim +'CocInstall -sync coc-tsserver coc-pyright' +qa || error "CocInstall failed (continuing)."
    success "Neovim configured!"
}

setup_zsh() {
    log "Configuring Zsh..."
    SHELL_ZSHRC_LOCAL="$SCRIPT_DIR/zsh/.zshrc.local"
    if [ ! -f "$SHELL_ZSHRC_LOCAL" ]; then
        error "zsh/.zshrc.local not found."
        return 1
    fi
    backup_file "$HOME/.zshrc.local"
    ln -sf "$SHELL_ZSHRC_LOCAL" "$HOME/.zshrc.local"
    if ! grep -q "source ~/.zshrc.local" "$HOME/.zshrc" 2>/dev/null; then
        echo -e "\n# Load local zsh customizations\n[ -f ~/.zshrc.local ] && source ~/.zshrc.local" >> "$HOME/.zshrc"
    fi
    success "Zsh configured!"
}

setup_starship() {
    log "Configuring Starship..."
    SHELL_STARSHIP_TOML="$SCRIPT_DIR/starship/starship.toml"
    if [ -f "$SHELL_STARSHIP_TOML" ]; then
        mkdir -p "$HOME/.config"
        backup_file "$HOME/.config/starship.toml"
        ln -sf "$SHELL_STARSHIP_TOML" "$HOME/.config/starship.toml"
        success "Starship configured!"
    else
        log "starship/starship.toml not found. Skipping."
    fi
}

setup_ghostty() {
    log "Configuring Ghostty..."
    SHELL_GHOSTTY_LOCAL="$SCRIPT_DIR/ghostty/.ghostty.local"
    if [ -f "$SHELL_GHOSTTY_LOCAL" ]; then
        mkdir -p "$HOME/.config/ghostty"
        backup_file "$HOME/.config/ghostty/config"
        ln -sf "$SHELL_GHOSTTY_LOCAL" "$HOME/.config/ghostty/config"
        success "Ghostty configured!"
    else
        log "ghostty/.ghostty.local not found. Skipping."
    fi
}

setup_tmux() {
    log "Configuring Tmux..."
    SHELL_TMUX_CONF="$SCRIPT_DIR/tmux/.tmux.conf"
    if [ ! -f "$SHELL_TMUX_CONF" ]; then
        log "tmux/.tmux.conf not found. Skipping."
        return 0
    fi
    backup_file "$HOME/.tmux.conf"
    ln -sf "$SHELL_TMUX_CONF" "$HOME/.tmux.conf"
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        if ! command -v git &> /dev/null; then
            error "git not found. Skipping tpm clone."
        else
            git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm &> /dev/null || error "tpm clone failed."
        fi
    fi
    success "Tmux configured!"
}

setup_antigravity() {
    log "Installing Antigravity CLI..."
    if [ ! -f "$SCRIPT_DIR/antigravity/install.sh" ]; then
        error "Antigravity installation script not found."
        return 1
    fi
    bash "$SCRIPT_DIR/antigravity/install.sh"
    success "Antigravity CLI installed!"
}

setup_cmux_config() {
    log "Configuring cmux..."
    SHELL_CMUX_JSON="$SCRIPT_DIR/cmux/cmux.json"
    if [ ! -f "$SHELL_CMUX_JSON" ]; then
        log "cmux/cmux.json not found. Skipping."
        return 0
    fi
    mkdir -p "$HOME/.config/cmux"
    backup_file "$HOME/.config/cmux/cmux.json"
    ln -sf "$SHELL_CMUX_JSON" "$HOME/.config/cmux/cmux.json"
    success "cmux configured!"
}

# --- 메인 메뉴 및 실행 로직 ---

COMPONENTS=("Homebrew" "Neovim" "Zsh" "Starship" "Ghostty" "Tmux" "Antigravity" "cmux-config")
SELECTED=(true true true true true true false true)
CURSOR=0

show_menu() {
    print_header
    echo -e "  ${YELLOW}Use [Up/Down] to navigate, [Space] to toggle, [Enter] to start${NC}\n"
    for i in "${!COMPONENTS[@]}"; do
        if [ "$i" -eq "$CURSOR" ]; then
            printf "  %b%b❯%b " "${BLUE}" "${BOLD}" "${NC}"
        else
            printf "    "
        fi

        if [ "${SELECTED[i]}" = true ]; then
            printf " %b%b%b " "${GREEN}" "${CHECK}" "${NC}"
        else
            printf " %b%b%b " "${RED}" "${CROSS}" "${NC}"
        fi

        if [ "$i" -eq "$CURSOR" ]; then
            printf "%b%b%s%b\n" "${WHITE}" "${BOLD}" "${COMPONENTS[i]}" "${NC}"
        else
            printf "%b%s\n" "${NC}" "${COMPONENTS[i]}"
        fi
    done
    echo ""
}

# Capture arrow keys and other inputs
get_input() {
    local key
    IFS= read -rn1 -s key
    case "$key" in
        $'\x1b') # ESC sequence
            # 두 번째 바이트를 짧은 타임아웃으로 시도 — 단독 ESC 입력 시 무한 대기 방지
            read -rn2 -s -t 0.1 key || key=""
            case "$key" in
                '[A') echo "UP" ;;
                '[B') echo "DOWN" ;;
            esac
            ;;
        " ") echo "SPACE" ;;
        "")  echo "ENTER" ;;
        "a") echo "ALL" ;;
        "n") echo "NONE" ;;
        "q") echo "QUIT" ;;
    esac
}

# 비-TTY 환경(CI/pipe) 가드 — read EOF + set -e 조합으로 무음 크래시 방지
if [ ! -t 0 ] || [ ! -t 1 ]; then
    echo "Non-interactive terminal detected. This installer requires a TTY." >&2
    echo "Run from a real terminal, or set SELECTED defaults and skip the menu by modifying the script." >&2
    exit 1
fi

while true; do
    show_menu
    input=$(get_input)
    case "$input" in
        UP)    CURSOR=$(( (CURSOR - 1 + ${#COMPONENTS[@]}) % ${#COMPONENTS[@]} )) ;;
        DOWN)  CURSOR=$(( (CURSOR + 1) % ${#COMPONENTS[@]} )) ;;
        SPACE) SELECTED[CURSOR]=$([ "${SELECTED[CURSOR]}" = true ] && echo false || echo true) ;;
        ALL)   for i in "${!SELECTED[@]}"; do SELECTED[i]=true; done ;;
        NONE)  for i in "${!SELECTED[@]}"; do SELECTED[i]=false; done ;;
        ENTER) break ;;
        QUIT)  echo "Installation cancelled."; exit 0 ;;
    esac
done

echo -e "\n${YELLOW}${STAR} Starting installation...${NC}\n"

if [ "${SELECTED[0]}" = true ]; then setup_homebrew; fi
if [ "${SELECTED[1]}" = true ]; then setup_neovim; fi
if [ "${SELECTED[2]}" = true ]; then setup_zsh; fi
if [ "${SELECTED[3]}" = true ]; then setup_starship; fi
if [ "${SELECTED[4]}" = true ]; then setup_ghostty; fi
if [ "${SELECTED[5]}" = true ]; then setup_tmux; fi
if [ "${SELECTED[6]}" = true ]; then setup_antigravity; fi
if [ "${SELECTED[7]}" = true ]; then setup_cmux_config; fi

echo -e "\n${GREEN}${BOLD}${STAR} Setup completed successfully!${NC}"
echo -e "${CYAN}Please restart your terminal or run 'source ~/.zshrc' to apply changes.${NC}"
