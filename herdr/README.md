# Herdr 키 바인딩 정리 (tmux 패리티 기준)

> 기준 설정: `herdr/config.toml` (심링크 → `~/.config/herdr/config.toml`)
> **Prefix 키는 tmux와 동일하게 `Ctrl-a`** 로 맞춰져 있습니다. (herdr 기본값은 `Ctrl-b`)

[Herdr](https://herdr.dev)는 AI 코딩 에이전트를 위한 터미널 멀티플렉서입니다. tmux와 계층 개념이 조금 다릅니다.

| tmux 개념 | Herdr 개념 |
|---|---|
| session | **workspace** (좌측 사이드바 단위) |
| window | **tab** |
| pane | **pane** |
| (없음) | **sidebar** (에이전트/워크스페이스 패널) |

---

## 1) tmux와 키가 동일한 바인딩

| 기능 | 키 | 비고 |
|---|---|---|
| 새 탭(=window) | `Ctrl-a c` | tmux `prefix c` |
| 다음 탭 | `Ctrl-a n` | tmux `prefix n` |
| 이전 탭 | `Ctrl-a p` | tmux `prefix p` |
| 번호로 탭 이동 | `Ctrl-a 1`~`9` | tmux `prefix <번호>` |
| 패널 이동 (vim) | `Ctrl-a h/j/k/l` | tmux `prefix h/j/k/l` |
| 패널 닫기 | `Ctrl-a x` | tmux `prefix x` |
| 패널 확대(줌) | `Ctrl-a z` | tmux `prefix z` |

## 2) tmux에 맞추려고 변경한 바인딩

| 기능 | 키 | Herdr 기본값 | 비고 |
|---|---|---|---|
| Prefix | `Ctrl-a` | `Ctrl-b` | tmux와 동일하게 |
| 좌우 분할 | `Ctrl-a \|` | `Ctrl-a v` (`split_vertical`) | tmux `prefix \|` |
| 상하 분할 | `Ctrl-a -` | `Ctrl-a -` (`split_horizontal`) | tmux `prefix -` (기본값과 동일) |
| 새 workspace(=세션) | `Ctrl-a Shift-s` | `Ctrl-a Shift-n` | tmux `prefix S` |
| 설정 리로드 | `Ctrl-a r` | `Ctrl-a Shift-r` | tmux `prefix r` |
| 패널 크기 조절 모드 | `Ctrl-a Shift-r` | `Ctrl-a r` (`resize_mode`) | 리로드에 `r`을 넘겨주며 자리 교환 |

> **split 용어 주의**: Herdr의 `split_vertical`/`split_horizontal`은 tmux의 `-h`/`-v`와 **이름이 반대**입니다.
> 이 설정은 이름이 아니라 **동작과 키**를 기준으로 맞췄습니다 — `|`는 좌우, `-`는 상하 분할입니다.

## 3) tmux에서 1:1로 옮길 수 없는 것

- **복사 모드(copy-mode)**: tmux의 `prefix Enter` + vi 선택(`v`/`y`)에 대응하는 프리픽스 액션이 Herdr에는 없습니다.
  대신 **마우스 드래그 복사**(`copy_on_select`, 기본 켜짐)와 **스크롤백 편집** `Ctrl-a e`(`edit_scrollback`)를 사용합니다.

## 4) Herdr 고유 기능 (tmux에 없음)

| 기능 | 키 |
|---|---|
| 워크스페이스 선택기 | `Ctrl-a w` |
| 사이드바 토글 | `Ctrl-a b` |
| 도움말 | `Ctrl-a ?` |
| 설정 화면 | `Ctrl-a s` |
| 디태치 | `Ctrl-a q` |

전체 기본값과 추가 옵션은 `herdr --default-config` 로 확인할 수 있습니다.

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
