# cmux-tmux Sync

tmux 세션이 생성/삭제될 때 cmux workspace를 자동으로 동기화하는 launchd User Agent. 30초마다 실행하며, `tmux:` prefix가 붙은 workspace만 관리합니다.

## 사전 준비

- tmux 설치 및 실행 중
- cmux 설치 및 데몬 실행 중 (`brew install --cask cmux`)
- `~/Library/LaunchAgents/` 디렉토리 존재

## 설치

### init.sh 메뉴

```bash
./init.sh
# 메뉴에서 "cmux-sync"를 Space로 선택 후 Enter
```

## 제거

```bash
launchctl bootout gui/$(id -u)/com.user.cmux-sync
rm ~/Library/LaunchAgents/com.user.cmux-sync.plist
```

## 로그 확인

```bash
tail -f ~/Library/Logs/cmux-sync.log
```

## 트러블슈팅

| 증상 | 확인 사항 |
|------|-----------|
| 동기화 안 됨 | `launchctl print gui/$(id -u)/com.user.cmux-sync` 실행 상태 및 last exit code 확인 |
| cmux 오류 | cmux 소켓 경로 `~/Library/Application Support/cmux/cmux.sock` 존재 확인, cmux 데몬 실행 여부 확인 |
| PATH 문제 | plist의 `EnvironmentVariables` → `PATH`에 `/opt/homebrew/bin` 포함 여부 확인 |
| 잠금 충돌 | `ls -ld /tmp/cmux-sync.lock` 디렉토리 존재 확인. 비정상 종료 후 stale lock → `rmdir /tmp/cmux-sync.lock` |
| 스크립트 오류 | `cat ~/Library/Logs/cmux-sync.log` 로그 확인 |
