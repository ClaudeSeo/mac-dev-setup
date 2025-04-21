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
        brew update
    fi
    
    # Brewfile이 있는지 확인하고 번들 설치
    if [ -f "$SCRIPT_DIR/brew/Brewfile" ]; then
        log "Brewfile을 사용하여 패키지를 설치합니다..."
        cd "$SCRIPT_DIR/brew" && brew bundle
        cd "$SCRIPT_DIR"
    else
        log "Brewfile을 찾을 수 없습니다."
        exit 1
    fi
    
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

# 메인 실행 함수
main() {
    log "macOS 개발 환경 설정을 시작합니다..."
    
    # Homebrew 설정
    setup_homebrew
    
    # Neovim 설정
    setup_neovim
    
    log "macOS 개발 환경 설정이 완료되었습니다!"
    log "일부 설정은 터미널을 재시작하거나 새 세션에서 적용됩니다."
}

# 스크립트 실행
main
