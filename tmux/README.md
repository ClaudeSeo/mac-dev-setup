# tmux 주요 명령어 정리 (기본 + 현재 커스텀)

> 기준 설정: `tmux/.tmux.conf`  
> **Prefix 키는 `Ctrl-b`가 아니라 `Ctrl-a`** 로 변경되어 있습니다.

## 1) 세션(Session) 명령어

### 터미널에서

| 기능 | 명령어 |
|---|---|
| 새 세션 생성 | `tmux new -s <session-name>` |
| 세션 목록 보기 | `tmux ls` |
| 세션 접속 | `tmux attach -t <session-name>` |
| 세션 종료 | `tmux kill-session -t <session-name>` |
| 빠른 접속 (alias) | `tm` → `tmux new-session -A -s main` |

### Prefix 키

| 기능 | 키 |
|---|---|
| 세션에서 나가기(유지) | `Ctrl-a d` |
| 세션 목록 (인터랙티브) | `Ctrl-a s` |
| 세션 이름 변경 | `Ctrl-a $` |
| 이전 세션으로 이동 | `Ctrl-a (` |
| 다음 세션으로 이동 | `Ctrl-a )` |
| 마지막 세션으로 토글 | `Ctrl-a L` |
| 새 세션 생성 | `Ctrl-a S` *(커스텀, 이름 입력 프롬프트)* |

### 세션 목록(`Ctrl-a s`) 내부 키

| 기능 | 키 |
|---|---|
| 이동 | `j`/`k` 또는 `↑`/`↓` |
| 트리 펼치기/접기 | `l`/`h` 또는 `→`/`←` |
| 선택한 항목으로 전환 | `Enter` |
| 세션 이름 변경 | `r` |
| 세션 종료 | `x` (확인 프롬프트) |
| 태그(마킹) | `t` |
| 태그된 항목 일괄 종료 | `X` |
| 나가기 | `q` |

---

## 2) 윈도우(Window) 주요 명령어

| 기능 | 기본/커스텀 키 |
|---|---|
| 새 윈도우 생성 | `Ctrl-a c` *(커스텀: 현재 경로 유지)* |
| 다음 윈도우 | `Ctrl-a n` |
| 이전 윈도우 | `Ctrl-a p` |
| 윈도우 번호로 이동 | `Ctrl-a <번호>` |
| 윈도우 이름 변경 | `Ctrl-a ,` |
| 윈도우 닫기 | `Ctrl-a &` |

---

## 3) 패널(Pane) 주요 명령어

| 기능 | 기본/커스텀 키 |
|---|---|
| 좌우 분할 | `Ctrl-a |` *(커스텀, `split-window -h`)* |
| 상하 분할 | `Ctrl-a -` *(커스텀, `split-window -v`)* |
| 패널 이동 | `Ctrl-a h/j/k/l` *(커스텀, vim 스타일)* |
| 패널 닫기 | `Ctrl-a x` |
| 레이아웃 순환 | `Ctrl-a Space` |
| 패널 번호 표시 | `Ctrl-a q` |

> 참고: 기본 분할 키인 `"` / `%` 는 이 설정에서 해제됨.

---

## 4) 복사 모드(Copy Mode, vi) 명령어

| 기능 | 키 |
|---|---|
| 복사 모드 진입 | `Ctrl-a Enter` *(커스텀)* |
| 선택 시작 | `v` |
| 블록 선택(직사각형) | `Ctrl-v` |
| 복사 후 종료 | `y` |
| 취소 | `Esc` |

추가 설정:
- `mode-keys vi` 사용
- 마우스 휠 업 시 상황에 따라 복사 모드 자동 진입 동작 포함

---

## 5) 기타 커스텀 핵심

| 기능 | 키/설정 |
|---|---|
| tmux 설정 리로드 | `Ctrl-a r` |
| Prefix 자체 전송 | `Ctrl-a Ctrl-a` |
| 마우스 사용 | `set -g mouse on` |
| 클립보드 연동 | `set -g set-clipboard on` |
| 윈도우/패널 번호 시작 | 1부터 (`base-index 1`, `pane-base-index 1`) |
| 스크롤백 버퍼 | `50000` |
| 윈도우 번호 자동 재정렬 | `renumber-windows on` |

---

## 6) 플러그인 관련(참고)

- TPM: `tmux-plugins/tpm`
- sensible, resurrect, continuum, yank 사용
- resurrect/continuum으로 세션 자동 저장/복원 설정 포함
