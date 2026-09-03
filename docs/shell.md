# 셸, 프롬프트, 터미널, Git 설정

> `zsh/.zshrc.local`, `starship/starship.toml`, `ghostty/.ghostty.local`, `git/` 설정 파일이 각각 무엇을 바꾸는지 정리했습니다. ← [README](../README.md)

## Zsh (`zsh/.zshrc.local`)

`init.sh`가 `~/.zshrc.local`로 심링크하고 `~/.zshrc` 끝에서 source하도록 한 줄을 추가합니다. 기존 `~/.zshrc`는 그대로 두고 그 위에 얹는 구조예요.

| 항목 | 내용 |
|---|---|
| 프롬프트 | `starship init zsh` |
| 이동 | `AUTO_CD` (디렉터리 이름만 입력해도 이동), `zoxide init` |
| Completion | 대소문자 무시 매칭, `zsh-completions`, `kubectl completion zsh`, `ut completions zsh` |
| 자동 제안과 문법 강조 | `zsh-autosuggestions`, `zsh-syntax-highlighting` (Homebrew 경로에서 로드) |
| 런타임 관리 | `fnm env --use-on-cd` (디렉터리 진입 시 Node 버전 전환), SDKMAN (`sdkman-cli` 포뮬러 경로), gvm이 있으면 로드 |
| 환경 변수 | `direnv hook zsh` |
| 퍼지 검색 | `fzf --zsh` (Ctrl-R 히스토리 검색 등) |
| 파일 디스크립터 | `ulimit -n 4096` |

별칭(`l`, `tree`, `k`, `npmr`, `tm`, `hr`, `cca` 등)은 [명령어 참조](tools.md)의 사용자 정의 별칭 표를 참고하세요.

## Starship (`starship/starship.toml`)

프롬프트는 한 줄에 `custom.claude → 디렉터리 → Git 브랜치/상태 → 언어 버전 → Docker 컨텍스트 → 실행 시간 → 시각`을 표시하고, 다음 줄에 `❯` 문자를 둡니다.

| 모듈 | 설정 |
|---|---|
| `custom.claude` | `claude` 뒤에 무작위 이모지 하나를 붙여 주황색으로 표시 |
| `directory` | 경로를 자르지 않고 전체 표시 (`truncation_length = 0`) |
| 언어 모듈 | Node, Python, Kotlin, Java, Go, Rust, Ruby, PHP: `이름(버전)` 형식 |
| `docker_context` | `docker(컨텍스트)` 형식 |
| `kubernetes` | 비활성화 |
| `time` | `HH:MM`, 노란색 |
| `character` | 성공 시 초록 `❯`, 실패 시 빨간 `❯` |

## Ghostty (`ghostty/.ghostty.local`)

| 설정 | 값 |
|---|---|
| 테마 | Monokai Pro |
| 폰트 | Hack Nerd Font Mono, 대체 폰트 D2Coding, 13pt (둘 다 Brewfile 캐스크로 설치) |
| 벨 | 소리, 주의 표시, 제목 표시 |
| `opt+backspace` | `Ctrl+W`(`\x17`) 바이트를 전송해 단어 단위 삭제 |

`opt+backspace` 매핑은 Ghostty 1.2가 내장 매핑을 제거했고 `macos-option-as-alt`가 꺼진 상태에서는 이 키가 아무것도 보내지 않기 때문에 넣은 설정입니다. `Ctrl+W`는 셸, Herdr 어디서나 통하는 시퀀스라 이것으로 대체했습니다.

## Git (`git/.gitconfig`, `git/.gitignore_global`)

> [!WARNING]
> `[user]` 섹션의 `name`, `email`, `signingkey`는 저장소 소유자 값입니다. 사용하기 전에 본인 정보로 바꾸세요.

| 설정 | 값 |
|---|---|
| 별칭 | `co`(checkout), `br`(branch), `ci`(commit), `st`(status), `unstage`(reset HEAD --), `last`(log -2 HEAD -p), `hide`/`unhide`(assume-unchanged 토글) |
| push | `autoSetupRemote = true`, `default = current` |
| pull | `rebase = true` |
| 편집기 | `nvim` |
| 커밋 서명 | SSH 키 서명 (`gpg.format = ssh`, `commit.gpgsign = true`, 키는 `~/.ssh/github`) |
| 전역 gitignore | `core.excludesfile = ~/.gitignore_global` (`init.sh`가 같은 경로로 심링크) |

`.gitignore_global`은 AI 코딩 에이전트가 만드는 작업 파일(`.claude/worktrees/`, `.codegraph/`, `.workflow-docs/` 아래 spec 이외 파일, `.agents/lessons.md`, `.claude/settings.local.json` 등)과 `.DS_Store`를 모든 저장소에서 제외합니다.
