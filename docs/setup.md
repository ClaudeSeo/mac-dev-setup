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
| Git | `git/.gitconfig` → `~/.gitconfig`, `git/.gitignore_global` → `~/.gitignore_global` 심링크 | 없음 |
| Tinycast | `tinycast/settings.json` → `~/.config/tinycast/settings.json` 심링크 | 없음 (앱은 Brewfile cask로 설치) |

Homebrew 항목을 함께 선택하면 `brew bundle`이 먼저 실행되므로 `nvim` 선행 조건이 자동으로 충족됩니다.

## 백업 규칙

연결 대상에 이미 일반 파일이 있으면 `<파일>.backup.<YYYYmmddHHMMSS>`로 이름을 바꾼 뒤 심링크를 만듭니다. 이미 심링크인 파일은 백업하지 않고 그대로 덮어씁니다. 그래서 `./init.sh`를 여러 번 실행해도 백업 파일이 쌓이지 않아요.

## 다시 실행하기

설정 파일을 바꾼 뒤에는 심링크라서 다시 실행할 필요가 없습니다. 새 패키지를 아래 카테고리 파일에 추가했다면 Homebrew 항목만 선택해 실행하거나, 직접 `cd brew && brew bundle`을 실행하세요.

## Homebrew 패키지 관리

[`brew/Brewfile`](../brew/Brewfile)은 전체 설치 진입점이며, 다음 파일을 명시된 순서로 읽습니다. 카테고리 파일은 독립 설치 목록이 아니라 전체 목록의 구성 요소입니다.

| 파일 (`brew/categories/`) | 용도 | 대표 항목 |
|---|---|---|
| [taps.Brewfile](../brew/categories/taps.Brewfile) | 외부 저장소와 `trusted` 설정 | `ClaudeSeo/tap`, `mongodb/brew` |
| [cli.Brewfile](../brew/categories/cli.Brewfile) | 셸, 파일 탐색, 텍스트 처리, 프로세스와 네트워크 도구 | `zsh`, `ripgrep`, `jq`, `zoxide` |
| [dev.Brewfile](../brew/categories/dev.Brewfile) | Git, 편집기, 런타임, 코드 검사 도구 | `git`, `neovim`, `uv`, `portress` |
| [infra.Brewfile](../brew/categories/infra.Brewfile) | 컨테이너, Kubernetes, 클라우드, 보안 도구 | `docker`, `helm`, `awscli`, `trivy` |
| [data.Brewfile](../brew/categories/data.Brewfile) | 데이터베이스와 Kafka 관련 도구 | `duckdb`, `mongocli`, `mongodb-grep` |
| [ai.Brewfile](../brew/categories/ai.Brewfile) | AI 모델과 코딩 에이전트 | `ollama`, `omp`, `codex`, `orca` |
| [desktop.Brewfile](../brew/categories/desktop.Brewfile) | 터미널 앱, 폰트, 데스크톱 도구 | `ghostty`, `font-d2coding`, `tinycast`, `herdr-app` |

패키지는 `brew`와 `cask` 구분보다 주 용도를 기준으로 한 파일에만 추가합니다. 외부 tap이 필요하면 `taps.Brewfile`에도 선언합니다. 새 카테고리는 파일을 만든 뒤 대표 `brew/Brewfile`의 로딩 목록에도 추가합니다.

저장소 루트에서 다음 명령으로 모든 카테고리가 읽히는지 확인합니다. 패키지를 설치하거나 업그레이드하지 않습니다.

```bash
brew bundle list --all --file=brew/Brewfile
```

주의: 카테고리 파일을 대상으로 `brew bundle cleanup --force`를 실행하면 다른 카테고리의 패키지와 tap 신뢰 설정이 제거 대상이 될 수 있습니다. 정리할 때는 대표 `brew/Brewfile`을 지정하고, 먼저 `--force` 없이 제거 대상을 확인합니다.

주의: `brew bundle dump --force`로 대표 파일을 덮어쓰지 않습니다. dump는 설치 상태를 단일 파일로 기록하므로 카테고리 로딩 구조를 보존하지 않습니다.

## 문제 해결

| 증상 | 원인과 조치 |
|---|---|
| `Non-interactive terminal detected` 후 종료 | 파이프나 CI에서 실행했습니다. 실제 터미널에서 실행하세요. |
| `nvim not found` 로 건너뜀 | Homebrew 항목을 먼저(또는 함께) 선택하거나 `nvim`을 직접 설치한 뒤 다시 실행하세요. |
| `Some packages failed to install.` | Brewfile 일부 설치 실패입니다. 나머지 항목은 계속 진행되므로 로그를 보고 `brew bundle`을 다시 실행하세요. |
| `CocInstall failed` | Neovim 안에서 `:CocInstall coc-tsserver coc-pyright`를 다시 실행하세요. |

설치가 끝나면 터미널을 재시작하거나 `source ~/.zshrc`를 실행합니다.

## 참고 자료

- [Homebrew Bundle 공식 문서](https://docs.brew.sh/Brew-Bundle-and-Brewfile): `list`, `cleanup`, `dump` 동작과 tap 신뢰 설정의 정리 기준
