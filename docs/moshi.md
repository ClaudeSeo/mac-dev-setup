# Moshi 설정

> AI 코딩 에이전트(Claude Code, Codex 등)를 Moshi 모바일 앱과 연결하는 데몬 `moshi-hook`의 페어링, hook 설치, 문제 해결입니다. ← [README](../README.md)
>
> 승인 요청을 폰으로 받아 응답하고, SSH/Mosh로 이 Mac에 접속할 수 있게 해 줍니다.

[moshi-hook](https://getmoshi.app)은 `brew/Brewfile`의 `rjyo/moshi/moshi-hook`으로 설치되며, `moshi`는 `moshi-hook`의 심링크입니다. 데몬(`moshi-hook serve`)은 `brew services`가 launchd 서비스(`homebrew.mxcl.moshi-hook`)로 관리합니다.

## 설치 후 설정

Homebrew 설치만으로는 데몬이 시작되지 않으므로 아래 순서로 한 번 설정합니다.

### 1. 폰과 페어링

Moshi 앱의 `Settings -> Integrations`에서 페어링 토큰을 발급받아 등록합니다. 토큰과 호스트 시크릿은 macOS Keychain에 저장됩니다.

```bash
moshi-hook pair --token <pairing-token>
```

### 2. 에이전트 hook 설치

지원하는 AI CLI의 설정 파일에 hook을 기록합니다. 대상을 지정하지 않으면 감지된 모든 CLI에 설치됩니다.

```bash
moshi-hook install                     # 전체
moshi-hook install --target claude     # Claude Code만
```

moshi-hook을 업그레이드하면 hook 형식이 바뀔 수 있습니다. `moshi-hook status`에서 `stale`로 표시되는 대상은 위 명령을 다시 실행해 갱신합니다.

### 3. 데몬 시작

```bash
brew services start moshi-hook
```

### 4. (선택) SSH/Mosh 접속 준비

폰에서 이 Mac의 터미널에 접속하려면 원격 로그인을 켜고 호스트를 페어링합니다. Mosh 방화벽 설정은 [Mosh 설정](mosh.md)를 참고하세요.

```bash
moshi-hook host enable-ssh
moshi-hook host setup
```

## 기본 사용법

| 기능 | 명령어 |
|---|---|
| 페어링과 hook 상태 확인 | `moshi-hook status` |
| 데몬 동작 여부 빠른 확인 | `moshi-hook probe` |
| 데몬 로그 추적 | `moshi-hook logs -f` |
| 현재 디렉터리에서 세션 열기 | `moshi .` |
| 로컬 웹 클라이언트 실행 | `moshi` |
| Git diff 뷰어 열기 | `moshi-hook diff <project-dir>` |
| 설정 조회와 변경 | `moshi-hook set`, `moshi-hook set <key> <value>` |
| 최신 버전으로 업데이트 | `moshi-hook update` |

자주 쓰는 설정 키는 다음과 같습니다. boolean 설정을 바꾼 뒤에는 데몬을 재시작해야 반영됩니다.

| 키 | 설명 |
|---|---|
| `suppress-push-while-unlocked` | Mac 잠금이 풀려 있는 동안 푸시 알림을 보내지 않음 |
| `suppress-nested-agent-push` | 다른 에이전트가 띄운 하위 에이전트의 알림을 보내지 않음 |
| `scan-ports` | HTTP 서버 탐지 대상 포트 (`all`, `none`, 또는 포트 목록) |
| `usage-collection` | 사용량 수집 주기 (`off` 또는 `5m` 같은 간격) |

## 주요 경로

| 항목 | 경로 |
|---|---|
| 데몬 소켓 | `~/Library/Application Support/Moshi/moshi-hook.sock` |
| 데몬 로그 | `~/Library/Application Support/Moshi/hook.log` |
| launchd 표준 출력 | `/opt/homebrew/var/log/moshi-hook.log` |
| launchd plist | `~/Library/LaunchAgents/homebrew.mxcl.moshi-hook.plist` |
| 로컬 게이트웨이 | `127.0.0.1:24543` |

## 문제 해결

### `brew services start`가 `Bootstrap failed: 5: Input/output error`로 실패함

```
Bootstrap failed: 5: Input/output error
Try re-running the command as root for richer errors.
```

`brew services info moshi-hook`이 `Loaded: true`, `Running: false`를 보이면 이 경우입니다. launchd에 서비스는 등록됐지만 프로세스가 뜨지 않은 상태에서 다시 `start`를 실행하면 중복 등록으로 오류 5가 납니다. 안내 문구와 달리 root 권한 문제가 아닙니다.

원인은 사용자 GUI 세션(`gui/501`)이 launchd의 on-demand-only 모드에 있어서 `RunAtLoad`/`KeepAlive` 서비스의 자동 실행이 보류되기 때문입니다. `launchctl print gui/$(id -u)`에서 `on-demand count`가 0보다 크면 이 상태입니다. launchd 로그에는 다음처럼 남습니다.

```
launchd[1] [gui/501]: pending spawn, domain in on-demand-only mode: homebrew.mxcl.moshi-hook
```

이때는 재등록(`brew services restart`) 대신 launchd에 직접 실행을 지시합니다.

```bash
launchctl kickstart -kp gui/$(id -u)/homebrew.mxcl.moshi-hook
moshi-hook probe   # running: true 확인
```

등록 자체가 꼬였다면 완전히 내린 뒤 다시 올립니다.

```bash
launchctl bootout gui/$(id -u)/homebrew.mxcl.moshi-hook
brew services start moshi-hook
```

launchd가 남긴 실제 사유는 다음 명령으로 확인할 수 있습니다. 셸에 `log` 함수가 정의되어 있으면 절대 경로로 실행해야 합니다.

```bash
/usr/bin/log show --last 15m --predicate 'process == "launchd" AND eventMessage CONTAINS "moshi"' --style compact
```

### 데몬은 도는데 폰에 알림이 오지 않음

`moshi-hook status`에서 `status: unpaired`이면 1번 페어링부터 다시 진행합니다. `paired`인데 hook이 `stale`이나 `not found`이면 `moshi-hook install --target <agent>`로 hook을 다시 설치합니다.
