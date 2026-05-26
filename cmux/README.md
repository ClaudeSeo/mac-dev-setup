# cmux

이 디렉토리는 cmux 관련 자산 두 가지를 관리합니다.

| 자산 | 용도 | 적용 방식 |
|------|------|-----------|
| `cmux.json` | cmux 앱 설정 (JSONC) | `~/.config/cmux/cmux.json`에 symlink |
| `com.user.cmux-sync.plist` + `sync-to-cmux.zsh` | tmux 세션 ↔ cmux workspace 자동 동기화 | launchd User Agent (30초 주기) |

## 1. cmux config (cmux.json)

`~/.config/cmux/cmux.json`을 이 저장소의 `cmux/cmux.json`으로 symlink하여 버전 관리합니다. tmux config (`.tmux.conf`)와 동일한 패턴입니다.

### 설치

```bash
./init.sh
# 메뉴에서 "cmux-config" 항목을 Space로 선택 후 Enter
```

`init.sh`의 `setup_cmux_config`가 다음을 수행합니다:

1. `~/.config/cmux/` 디렉토리 생성 (없으면)
2. 기존 `~/.config/cmux/cmux.json`이 일반 파일이면 `*.backup.YYYYMMDDHHMMSS`로 백업
3. 저장소의 `cmux.json`을 `~/.config/cmux/cmux.json`으로 symlink

### 적용 확인

```bash
ls -l ~/.config/cmux/cmux.json
# → ~/.config/cmux/cmux.json -> <repo>/cmux/cmux.json
```

설정을 바꾸고 싶다면 저장소 파일을 직접 편집한 뒤 cmux을 재시작하거나 `Cmd+Shift+,` (reloadConfiguration) 단축키로 다시 로드합니다.

### 주의사항

- `cmux.json`은 JSONC(주석 허용) 포맷입니다. 표준 JSON 파서로 검증하면 실패할 수 있습니다.
- cmux은 파일이 없으면 시작 시 빈 템플릿을 자동 생성합니다. 즉 한 번 symlink로 교체하면 그 뒤로는 저장소 파일만 따라갑니다.
- `automation.socketPassword` 등 민감 정보를 추가할 계획이라면, 이 파일을 `.gitignore`에 등록하거나 secrets 관리 도구로 분리하세요.

## 2. cmux-tmux Sync

tmux 세션이 생성/삭제될 때 cmux workspace를 자동으로 동기화하는 launchd User Agent. 30초마다 실행하며, `tmux:` prefix가 붙은 workspace만 관리합니다.

### 사전 준비

- tmux 설치 및 실행 중
- cmux 설치 및 데몬 실행 중 (`brew install --cask cmux`)
- `~/Library/LaunchAgents/` 디렉토리 존재

### 설치

```bash
./init.sh
# 메뉴에서 "cmux-sync"를 Space로 선택 후 Enter
```

### 제거

```bash
launchctl bootout gui/$(id -u)/com.user.cmux-sync
rm ~/Library/LaunchAgents/com.user.cmux-sync.plist
```

### 로그 확인

```bash
tail -f ~/Library/Logs/cmux-sync.log
```

### 트러블슈팅

| 증상 | 확인 사항 |
|------|-----------|
| 동기화 안 됨 | `launchctl print gui/$(id -u)/com.user.cmux-sync` 실행 상태 및 last exit code 확인 |
| cmux 오류 | cmux 소켓 경로 `~/Library/Application Support/cmux/cmux.sock` 존재 확인, cmux 데몬 실행 여부 확인 |
| PATH 문제 | plist의 `EnvironmentVariables` → `PATH`에 `/opt/homebrew/bin` 포함 여부 확인 |
| 잠금 충돌 | `ls -ld /tmp/cmux-sync.lock` 디렉토리 존재 확인. 비정상 종료 후 stale lock → `rmdir /tmp/cmux-sync.lock` |
| 스크립트 오류 | `cat ~/Library/Logs/cmux-sync.log` 로그 확인 |
