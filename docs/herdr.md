# Herdr 키 바인딩과 Worktrunk

> `herdr/config.toml`(심링크 → `~/.config/herdr/config.toml`)의 키맵과 Worktrunk 플러그인 정리입니다. ← [README](../README.md)
>
> **Prefix 키는 `Ctrl-a`** 로 맞춰져 있습니다. (herdr 기본값은 `Ctrl-b`)

[Herdr](https://herdr.dev)는 AI 코딩 에이전트를 위한 터미널 멀티플렉서입니다. 계층 개념은 다음과 같습니다.

| Herdr 개념 | 의미 |
|---|---|
| **workspace** | 좌측 사이드바 단위 (프로젝트 묶음) |
| **tab** | workspace 안의 화면 단위 |
| **pane** | tab 안의 분할 패널 |
| **sidebar** | 에이전트/워크스페이스 패널 |

---

## 1) 기본값 그대로 쓰는 바인딩

| 기능 | 키 |
|---|---|
| 새 탭 | `Ctrl-a c` |
| 다음 탭 | `Ctrl-a n` |
| 이전 탭 | `Ctrl-a p` |
| 번호로 탭 이동 | `Ctrl-a 1`~`9` |
| 패널 이동 (vim) | `Ctrl-a h/j/k/l` |
| 패널 닫기 | `Ctrl-a x` |
| 패널 확대(줌) | `Ctrl-a z` |

## 2) 기본값에서 변경한 바인딩

| 기능 | 키 | Herdr 기본값 | 비고 |
|---|---|---|---|
| Prefix | `Ctrl-a` | `Ctrl-b` | |
| 좌우 분할 | `Ctrl-a \|` | `Ctrl-a v` (`split_vertical`) | 세로 구분선 |
| 상하 분할 | `Ctrl-a -` | `Ctrl-a -` (`split_horizontal`) | 가로 구분선 (기본값과 동일) |
| 새 workspace | `Ctrl-a Shift-s` | `Ctrl-a Shift-n` | |
| 설정 리로드 | `Ctrl-a r` | `Ctrl-a Shift-r` | |
| 패널 크기 조절 모드 | `Ctrl-a Shift-e` | `Ctrl-a r` (`resize_mode`) | 리로드와 Worktrunk 원격 선택기에 자리를 양보하며 이동 |
| 디태치 | `Ctrl-a d` | `Ctrl-a q` | |
| 이전 에이전트 | `Ctrl-a [` | (미설정) | |
| 다음 에이전트 | `Ctrl-a ]` | (미설정) | |
| 탭 닫기 | `Ctrl-a &` | `Ctrl-a Shift-x` | |
| 워크스페이스 이름 변경 | `Ctrl-a $` | `Ctrl-a Shift-w` | |
| 직전 패널 전환 | `Ctrl-a ;` | (미설정) | |
| 다음 패널 순환 | `Ctrl-a o` | `Ctrl-a Tab` | 알림 열기는 Shift-o로 이동 |

> **split 용어 주의**: Herdr의 `split_vertical`은 세로 구분선(좌우 분할), `split_horizontal`은 가로 구분선(상하 분할)입니다.
> 이 설정은 키 모양을 기준으로 맞췄습니다: `|`는 좌우, `-`는 상하 분할입니다.

## 3) 복사와 붙여넣기

- **복사**: 프리픽스 기반 복사 모드 액션이 Herdr에는 없습니다.
  대신 **마우스 드래그 복사**(`copy_on_select`, 기본 켜짐)와 **스크롤백 편집** `Ctrl-a e`(`edit_scrollback`)를 사용합니다.
- **붙여넣기**: 별도 프리픽스 액션 없이 터미널 붙여넣기(`Cmd-v`)를 사용합니다.

## 4) 그 밖의 바인딩

| 기능 | 키 |
|---|---|
| 워크스페이스 선택기 | `Ctrl-a w` |
| 사이드바 토글 | `Ctrl-a b` |
| 도움말 | `Ctrl-a ?` |
| 세션 네비게이터(goto) | `Ctrl-a s` (herdr 기본 `Ctrl-a g`, settings보다 자주 써서 `s` 자리 사용) |
| 설정 화면 | `Ctrl-a ,` (herdr 기본 `Ctrl-a s`, goto에 자리 양보) |
| 스크롤백 편집 | `Ctrl-a e` |
| 로컬 또는 원격 브랜치 worktree 선택기 | `Ctrl-a Shift-r` |
| worktree 제거 | `Ctrl-a Shift-d` |
| 패널 이름 변경 | `Ctrl-a Shift-p` |
| 이전 패널 순환 | `Ctrl-a Shift-Tab` |
| 워크스페이스 닫기 | `Ctrl-a Shift-x` |
| 알림 대상 열기 | `Ctrl-a Shift-o` (다음 패널 순환과 자리 교환) |

전체 기본값과 추가 옵션은 `herdr --default-config` 로 확인할 수 있습니다.

---

## 5) Worktrunk 플러그인

[Worktrunk](https://github.com/devashish2203/herdr-worktrunk)는 `wt` 명령으로 Git worktree를 만들고 전환하는 Herdr 플러그인입니다. worktree 생성과 삭제 때 hook을 실행할 수 있어 에이전트별 작업 디렉터리를 관리하기 좋습니다.

### 설정

`init.sh`에서 Herdr를 선택하면 다음 순서로 설정합니다.

1. `worktrunk` 플러그인이 없을 때만 `devashish2203/herdr-worktrunk`에서 설치합니다.
2. 설치되어 있거나 새로 설치한 플러그인을 `enable` 상태로 맞춥니다.
3. 관리 설정의 다음 키를 Worktrunk action에 연결하고 실행 중인 서버에 다시 읽힙니다.
   - `prefix+shift+r`: 로컬 또는 원격 브랜치 선택기(`worktrunk.open-with-remotes`)
   - `prefix+shift+d`: worktree 제거(`worktrunk.remove`)
4. 위 키와 충돌하는 기본 기능은 `resize_mode`를 `prefix+shift+e`로, `close_workspace`를 `prefix+shift+x`로 옮겨 함께 유지합니다.

Homebrew를 함께 선택하면 `brew/Brewfile`에서 `worktrunk`, `fzf`, `jq`를 설치합니다. Herdr만 선택하는 경우에는 먼저 다음 요구사항을 직접 준비하세요.

### 요구사항

- Herdr 0.7.0 이상, Worktrunk 0.60.0 이상 (플러그인 README 기준)
- `wt` 명령이 `PATH`에 있어야 함 (`brew/Brewfile`의 `worktrunk` 포뮬러가 제공)
- `fzf`, `jq`, Bash

### 사용

다음 키를 누르면 Worktrunk picker 또는 제거 action을 실행할 수 있습니다.

- `Ctrl-a Shift-r`: 로컬 또는 원격 브랜치 기준 worktree 전환 또는 생성
- `Ctrl-a Shift-d`: 제거할 worktree를 선택한 뒤 제거

명령줄에서는 다음처럼 같은 action을 실행할 수 있습니다.

```bash
herdr plugin action invoke open-with-remotes --plugin worktrunk
herdr plugin action invoke remove --plugin worktrunk
```

### 검증과 문제 해결

설치 상태와 action 등록을 확인하고 설정을 다시 읽히려면 다음을 실행하세요.

```bash
herdr plugin list --plugin worktrunk --json
herdr plugin action list --plugin worktrunk
herdr server reload-config
```

플러그인이 없거나 비활성화되어 있으면 다음 명령으로 수동 설치와 활성화를 수행할 수 있습니다.

```bash
herdr plugin install devashish2203/herdr-worktrunk --yes
herdr plugin enable worktrunk
```

---
## 6) UI와 테마

`herdr/config.toml`의 키 바인딩 외 설정입니다.

| 설정 | 값 | 의미 |
|---|---|---|
| `ui.agent_panel_sort` | `spaces` | 에이전트 패널을 workspace 기준으로 그룹핑 |
| `ui.show_agent_labels_on_pane_borders` | `true` | 패널 테두리에 에이전트 이름 표시 |
| `ui.status_indicators` | `symbols` | 상태 표시를 기호로 |
| `theme.name` | `dracula` | Dracula 계열 테마 |
| `theme.auto_switch` | `false` | 시스템 라이트/다크 전환에 따라가지 않음 |
| `ui.toast.delivery` | `herdr` | 알림을 Herdr 내부 토스트로 전달 |
| `onboarding` | `false` | 첫 실행 온보딩 화면 생략 |

---

## 적용 및 검증

`init.sh`의 Herdr 항목을 선택하면 `herdr/config.toml`이 `~/.config/herdr/config.toml`로 심링크됩니다. 수동 적용/검증은 다음과 같습니다.

```bash
# 설정 검증
herdr config check

# 실행 중인 서버에 즉시 반영
herdr server reload-config

# 커스텀 키를 모두 되돌리기 (백업 후 제거)
herdr config reset-keys
```

## 참고 자료

- [herdr-worktrunk README](https://github.com/devashish2203/herdr-worktrunk): 플러그인 설치, 요구사항, action과 키 바인딩
- [Herdr CLI reference](https://herdr.dev/docs/cli-reference/): plugin list, install, enable과 action 명령
