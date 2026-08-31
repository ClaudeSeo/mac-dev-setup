# macOS 개발 환경 설정

> `./init.sh` 한 번으로 Homebrew 패키지 설치와 Zsh, Neovim, tmux, Ghostty, Starship, Herdr, Git 설정 연결을 끝내는 macOS dotfiles 저장소입니다.

[![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Shell](https://img.shields.io/badge/Shell-Zsh-1f425f?style=for-the-badge&logo=gnubash)](https://zsh.org/)
[![Homebrew](https://img.shields.io/badge/Homebrew-Latest-FBB040?style=for-the-badge&logo=homebrew)](https://brew.sh/)

## 무엇을 하나요

- **패키지 일괄 설치**: `brew/Brewfile`에 정의된 CLI 도구, 폰트, 앱을 `brew bundle`로 설치합니다. Homebrew가 없으면 먼저 설치합니다.
- **설정 파일 연결**: 저장소의 설정 파일을 홈 디렉터리에 심링크로 연결합니다. 이미 있는 파일은 `<파일>.backup.<타임스탬프>`로 백업한 뒤 교체합니다.
- **항목 선택 설치**: Homebrew, Neovim, Zsh, Starship, Ghostty, Tmux, Herdr, Git 8개 항목을 대화형 메뉴에서 골라 설치합니다.

## 빠른 시작

사전 준비: Xcode Command Line Tools (`xcode-select --install`)

```bash
git clone https://github.com/ClaudeSeo/mac-dev-setup
cd mac-dev-setup
./init.sh
```

메뉴에서 방향키로 이동하고 `Space`로 토글한 뒤 `Enter`로 시작합니다 (`a` 전체 선택, `n` 전체 해제, `q` 종료). 기본값은 8개 항목 모두 선택이에요. 설치가 끝나면 터미널을 재시작하거나 `source ~/.zshrc`를 실행하세요. 항목별로 정확히 무엇을 하는지는 [init.sh 동작 상세](docs/setup.md)에 있습니다.

> [!WARNING]
> `git/.gitconfig`에는 저장소 소유자의 `user.name`, `user.email`, SSH 서명 키 경로가 들어 있습니다. 다른 사람이 쓴다면 Git 항목을 선택하기 전에 본인 정보로 바꾸세요. Neovim과 Herdr 항목은 `nvim`, `herdr` 바이너리가 있어야 진행되므로 Homebrew 항목을 함께 선택하거나 미리 설치해 두세요.

## 구성 요소

| 항목 | 저장소 설정 파일 | 연결 위치 | 문서 |
|---|---|---|---|
| Homebrew | `brew/Brewfile` | `brew bundle`로 설치 | [명령어 참조](docs/tools.md) |
| Zsh | `zsh/.zshrc.local` | `~/.zshrc.local` (`~/.zshrc`에서 source) | [셸 설정](docs/shell.md) |
| Neovim | `nvim/init.vim` | `~/.config/nvim/init.vim` | [플러그인, 키맵, VSCode 모드](docs/neovim.md) |
| tmux | `tmux/.tmux.conf` | `~/.tmux.conf` | [키 바인딩 (Prefix `Ctrl-a`)](docs/tmux.md) |
| Starship | `starship/starship.toml` | `~/.config/starship.toml` | [셸 설정](docs/shell.md) |
| Ghostty | `ghostty/.ghostty.local` | `~/.config/ghostty/config` | [셸 설정](docs/shell.md) |
| Herdr | `herdr/config.toml` | `~/.config/herdr/config.toml` | [tmux 패리티 키맵과 Worktrunk](docs/herdr.md) |
| Git | `git/.gitconfig`, `git/.gitignore_global` | `~/.gitconfig`, `~/.gitignore_global` | [셸 설정](docs/shell.md) |
| Mosh | (Brewfile로 설치) | | [방화벽 허용, 비로그인 셸](docs/mosh.md) |
| Moshi | (Brewfile로 설치) | | [페어링, hook 설치, 문제 해결](docs/moshi.md) |

## 문서

전체 색인은 [docs/README.md](docs/README.md)에 있습니다.

- [init.sh 동작 상세](docs/setup.md): 항목별 작업, 백업 규칙, 문제 해결
- [명령어 참조](docs/tools.md): Brewfile로 설치되는 CLI 도구와 사용자 정의 별칭
- [권장 응용프로그램](docs/installation.md): Brewfile에 없어 직접 설치하는 앱
