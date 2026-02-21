#!/usr/bin/env bash
set -euo pipefail

# 로그 출력 함수
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# 현재 디렉토리 저장
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Homebrew 설정 및 패키지 설치
setup_homebrew() {
    log "Homebrew 설정을 시작합니다..."

    # 에러가 발생해도 계속 진행
    set +e

    # Homebrew가 설치되어 있는지 확인
    if ! command -v brew &> /dev/null; then
        log "Homebrew가 설치되어 있지 않습니다. 설치를 시작합니다..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Apple Silicon Mac인 경우 PATH 설정
        if [[ $(uname -m) == 'arm64' ]]; then
            log "Apple Silicon Mac을 감지했습니다. PATH를 설정합니다..."
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        log "Homebrew가 이미 설치되어 있습니다. 업데이트를 실행합니다..."
        brew update || log "brew update 실패, 계속 진행합니다."
    fi

    # Brewfile이 있는지 확인하고 번들 설치
    if [ -f "$SCRIPT_DIR/brew/Brewfile" ]; then
        log "Brewfile을 사용하여 패키지를 설치합니다..."
        cd "$SCRIPT_DIR/brew" && brew bundle || log "brew bundle 일부 실패, 계속 진행합니다."
        cd "$SCRIPT_DIR"
    else
        log "Brewfile을 찾을 수 없습니다. 건너뜁니다."
    fi

    # 에러 처리 모드 복원
    set -e

    log "Homebrew 설정이 완료되었습니다!"
}

# Neovim 설정
setup_neovim() {
    log "Neovim 설정을 시작합니다..."

    # Neovim 설정 디렉토리 생성
    NVIM_DIR="$HOME/.config/nvim"
    mkdir -p "$NVIM_DIR"
    log "Neovim 설정 디렉토리 생성: $NVIM_DIR"

    # init.vim 심볼릭 링크 생성
    if [ -f "$NVIM_DIR/init.vim" ]; then
        log "기존 init.vim 파일이 존재합니다. 백업 후 새로 설정합니다."
        mv "$NVIM_DIR/init.vim" "$NVIM_DIR/init.vim.backup.$(date +%Y%m%d%H%M%S)"
    fi

    ln -sf "$SCRIPT_DIR/nvim/init.vim" "$NVIM_DIR/init.vim"
    log "init.vim 설정 완료"

    # vim-plug 설치
    log "vim-plug 플러그인 매니저를 설치합니다."
    curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # Neovim 플러그인 설치 및 업데이트
    log "Neovim 플러그인을 설치합니다."
    nvim +PlugInstall +PlugUpdate +qa

    # CoC 확장 설치
    log "CoC 확장을 설치합니다."
    nvim \
        +'CocInstall coc-tsserver' \
        +'CocInstall coc-diagnostic' \
        +'CocInstall coc-eslint' \
        +'CocInstall coc-json' \
        +'CocInstall coc-pyright' \
        +qa

    log "Neovim 설정이 완료되었습니다!"
}

# zsh 설정 - .zshrc.local 심볼릭 링크 생성
setup_zshrc_local() {
    log "zsh 설정을 시작합니다..."
    
    # shell 디렉토리의 .zshrc.local 파일 경로
    SHELL_ZSHRC_LOCAL="$SCRIPT_DIR/shell/.zshrc.local"
    
    # shell/.zshrc.local 파일이 있는지 확인
    if [ ! -f "$SHELL_ZSHRC_LOCAL" ]; then
        log "shell/.zshrc.local 파일이 존재하지 않습니다. 오류가 발생했습니다."
        exit 1
    fi
    
    # .zshrc.local 심볼릭 링크 생성
    if [ -f "$HOME/.zshrc.local" ]; then
        log "기존 .zshrc.local 파일이 존재합니다. 백업 후 새로 설정합니다."
        mv "$HOME/.zshrc.local" "$HOME/.zshrc.local.backup.$(date +%Y%m%d%H%M%S)"
    fi
    
    ln -sf "$SHELL_ZSHRC_LOCAL" "$HOME/.zshrc.local"
    log ".zshrc.local 심볼릭 링크 설정 완료"
    
    # .zshrc에 .zshrc.local을 로드하는 코드가 있는지 확인
    if ! grep -q "source ~/.zshrc.local" "$HOME/.zshrc"; then
        log ".zshrc에 .zshrc.local 로드 코드를 추가합니다."
        echo '# Load local zsh customizations' >> "$HOME/.zshrc"
        echo '[ -f ~/.zshrc.local ] && source ~/.zshrc.local' >> "$HOME/.zshrc"
    fi
    
    log "zsh 설정이 완료되었습니다!"
}

# Starship 프롬프트 설정
setup_starship_config() {
    log "Starship 설정을 시작합니다..."

    SHELL_STARSHIP_TOML="$SCRIPT_DIR/shell/starship.toml"

    if [ ! -f "$SHELL_STARSHIP_TOML" ]; then
        log "shell/starship.toml 파일이 존재하지 않습니다. 건너뜁니다."
        return 0
    fi

    if [ -f "$HOME/.config/starship.toml" ]; then
        log "기존 starship.toml 파일이 존재합니다. 백업 후 새로 설정합니다."
        mv "$HOME/.config/starship.toml" "$HOME/.config/starship.toml.backup.$(date +%Y%m%d%H%M%S)"
    fi

    ln -sf "$SHELL_STARSHIP_TOML" "$HOME/.config/starship.toml"
    log "starship.toml 심볼릭 링크 설정 완료"

    log "Starship 설정이 완료되었습니다!"
}

# Ghostty 터미널 설정
setup_ghostty_config() {
    log "Ghostty 설정을 시작합니다..."

    # shell 디렉토리의 .ghostty.local 파일 경로
    SHELL_GHOSTTY_LOCAL="$SCRIPT_DIR/shell/.ghostty.local"

    # shell/.ghostty.local 파일이 있는지 확인
    if [ ! -f "$SHELL_GHOSTTY_LOCAL" ]; then
        log "shell/.ghostty.local 파일이 존재하지 않습니다. 건너뜁니다."
        return 0
    fi

    # Ghostty 설정 디렉토리 생성
    GHOSTTY_DIR="$HOME/.config/ghostty"
    mkdir -p "$GHOSTTY_DIR"

    # 기존 config 파일 백업 후 심볼릭 링크 생성
    if [ -f "$GHOSTTY_DIR/config" ]; then
        log "기존 Ghostty config 파일이 존재합니다. 백업 후 새로 설정합니다."
        mv "$GHOSTTY_DIR/config" "$GHOSTTY_DIR/config.backup.$(date +%Y%m%d%H%M%S)"
    fi

    ln -sf "$SHELL_GHOSTTY_LOCAL" "$GHOSTTY_DIR/config"
    log "Ghostty config 심볼릭 링크 설정 완료"

    log "Ghostty 설정이 완료되었습니다!"
}

# Zed 에디터 설정
setup_zed_config() {
    log "Zed 설정을 시작합니다..."

    ZED_SETTINGS="$SCRIPT_DIR/zed/settings.json"

    if [ ! -f "$ZED_SETTINGS" ]; then
        log "zed/settings.json 파일이 존재하지 않습니다. 건너뜁니다."
        return 0
    fi

    # Zed 설정 디렉토리 생성
    ZED_DIR="$HOME/.config/zed"
    mkdir -p "$ZED_DIR"

    # 기존 settings.json 파일 백업 후 심볼릭 링크 생성
    if [ -f "$ZED_DIR/settings.json" ] && [ ! -L "$ZED_DIR/settings.json" ]; then
        log "기존 Zed settings.json 파일이 존재합니다. 백업 후 새로 설정합니다."
        mv "$ZED_DIR/settings.json" "$ZED_DIR/settings.json.backup.$(date +%Y%m%d%H%M%S)"
    fi

    ln -sf "$ZED_SETTINGS" "$ZED_DIR/settings.json"
    log "Zed settings.json 심볼릭 링크 설정 완료"

    log "Zed 설정이 완료되었습니다!"
}

# tmux 설정
setup_tmux() {
    log "tmux 설정을 시작합니다..."

    SHELL_TMUX_CONF="$SCRIPT_DIR/shell/.tmux.conf"

    if [ ! -f "$SHELL_TMUX_CONF" ]; then
        log "shell/.tmux.conf 파일이 존재하지 않습니다. 건너뜁니다."
        return 0
    fi

    # 기존 .tmux.conf 파일 백업 후 심볼릭 링크 생성
    if [ -f "$HOME/.tmux.conf" ] && [ ! -L "$HOME/.tmux.conf" ]; then
        log "기존 .tmux.conf 파일이 존재합니다. 백업 후 새로 설정합니다."
        mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.backup.$(date +%Y%m%d%H%M%S)"
    fi

    ln -sf "$SHELL_TMUX_CONF" "$HOME/.tmux.conf"
    log ".tmux.conf 심볼릭 링크 설정 완료"

    # TPM (Tmux Plugin Manager) 설치
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        log "TPM (Tmux Plugin Manager)을 설치합니다..."
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        log "TPM 설치 완료. tmux 실행 후 prefix + I 로 플러그인을 설치하세요."
    else
        log "TPM이 이미 설치되어 있습니다."
    fi

    log "tmux 설정이 완료되었습니다!"
}

# 메인 실행 함수
main() {
    log "macOS 개발 환경 설정을 시작합니다..."
    
    # Homebrew 설정
    setup_homebrew
    
    # Neovim 설정
    setup_neovim
    
    # zsh 설정
    setup_zshrc_local

    # Starship 프롬프트 설정
    setup_starship_config

    # Ghostty 터미널 설정
    setup_ghostty_config

    # Zed 에디터 설정
    setup_zed_config

    # tmux 설정
    setup_tmux

    log "macOS 개발 환경 설정이 완료되었습니다!"
    log "일부 설정은 터미널을 재시작하거나 새 세션에서 적용됩니다."
}

# 스크립트 실행
main
