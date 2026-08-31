# init.sh 동작 상세

> `./init.sh`가 메뉴 항목별로 실제 수행하는 작업, 백업 규칙, 재실행과 문제 해결입니다. ← [README](../README.md)

## 메뉴 조작

| 키 | 동작 |
|---|---|
| `↑` / `↓` | 항목 이동 |
| `Space` | 선택 토글 |
| `a` / `n` | 전체 선택 / 전체 해제 |
| `Enter` | 선택한 항목 설치 시작 |
| `q` | 취소하고 종료 |

기본값은 8개 항목 모두 선택입니다. 스크립트는 표준 입력과 출력이 모두 TTY일 때만 실행되고, 파이프나 CI에서는 안내 문구를 남기고 종료합니다.

## 항목별 수행 작업

| 항목 | 수행 작업 | 선행 조건 |
|---|---|---|
| Homebrew | Homebrew가 없으면 공식 스크립트로 설치하고, Apple Silicon이면 `~/.zshrc`에 `brew shellenv` 줄을 추가합니다. 있으면 `brew update`만 합니다. 이어서 `brew/` 디렉터리에서 `brew bundle`을 실행합니다. | Xcode Command Line Tools |
| Neovim | `nvim/init.vim` → `~/.config/nvim/init.vim` 심링크, vim-plug 다운로드, `nvim +PlugInstall +PlugUpdate +qa`, `:CocInstall coc-tsserver coc-pyright` | `nvim` 바이너리 (없으면 건너뜀) |
| Zsh | `zsh/.zshrc.local` → `~/.zshrc.local` 심링크, `~/.zshrc`에 `source ~/.zshrc.local` 줄이 없으면 추가 | 없음 |
| Starship | `starship/starship.toml` → `~/.config/starship.toml` 심링크 | 없음 |
| Ghostty | `ghostty/.ghostty.local` → `~/.config/ghostty/config` 심링크 | 없음 |
| Tmux | `tmux/.tmux.conf` → `~/.tmux.conf` 심링크, TPM 클론(`~/.tmux/plugins/tpm`), `install_plugins.sh`로 플러그인 설치 | `git`, `tmux` |
| Herdr | `herdr/config.toml` → `~/.config/herdr/config.toml` 심링크, Worktrunk 플러그인이 없으면 설치 후 `enable`, 실행 중인 서버에 `reload-config` | `herdr`, `jq` (herdr가 없으면 건너뜀) |
| Git | `git/.gitconfig` → `~/.gitconfig`, `git/.gitignore_global` → `~/.gitignore_global` 심링크 | 없음 |

Homebrew 항목을 함께 선택하면 `brew bundle`이 먼저 실행되므로 `nvim`, `herdr`, `jq`, `tmux` 선행 조건이 자동으로 충족됩니다.

> [!WARNING]
> `git/.gitconfig`에는 저장소 소유자의 `user.name`, `user.email`, SSH 서명 키 경로가 들어 있습니다. 다른 사람이 쓰려면 Git 항목을 선택하기 전에 본인 정보로 바꾸세요.

## 백업 규칙

연결 대상에 이미 일반 파일이 있으면 `<파일>.backup.<YYYYmmddHHMMSS>`로 이름을 바꾼 뒤 심링크를 만듭니다. 이미 심링크인 파일은 백업하지 않고 그대로 덮어씁니다. 그래서 `./init.sh`를 여러 번 실행해도 백업 파일이 쌓이지 않아요.

## 다시 실행하기

설정 파일을 바꾼 뒤에는 심링크라서 다시 실행할 필요가 없습니다. 새 패키지를 Brewfile에 추가했다면 Homebrew 항목만 선택해 실행하거나, 직접 `cd brew && brew bundle`을 실행하세요.

## 문제 해결

| 증상 | 원인과 조치 |
|---|---|
| `Non-interactive terminal detected` 후 종료 | 파이프나 CI에서 실행했습니다. 실제 터미널에서 실행하세요. |
| `nvim not found` / `herdr not found` 로 건너뜀 | Homebrew 항목을 먼저(또는 함께) 선택하거나 해당 바이너리를 직접 설치한 뒤 다시 실행하세요. |
| `Some packages failed to install.` | Brewfile 일부 설치 실패입니다. 나머지 항목은 계속 진행되므로 로그를 보고 `brew bundle`을 다시 실행하세요. |
| `tmux plugin install failed` | tmux 안에서 `Ctrl-a I`를 눌러 TPM으로 직접 설치하세요. |
| `CocInstall failed` | Neovim 안에서 `:CocInstall coc-tsserver coc-pyright`를 다시 실행하세요. |
| `Failed to inspect installed Herdr plugins` | `herdr plugin list --plugin worktrunk --json` 출력이 비정상입니다. `jq` 설치 여부와 Herdr 버전을 확인하세요. |

설치가 끝나면 터미널을 재시작하거나 `source ~/.zshrc`를 실행합니다.
