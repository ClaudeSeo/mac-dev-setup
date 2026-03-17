# Mosh (Mobile Shell)

> SSH 대체 원격 터미널. UDP 기반으로 로밍, 네트워크 전환 시에도 세션 유지.

## 설치 후 설정

### 1. macOS 방화벽 허용

mosh-server가 UDP 포트(60000-61000)를 사용하므로 방화벽에 등록해야 합니다.

```bash
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add $(which mosh-server)
```

### 2. brew 환경변수 로드 (비로그인 셸 지원)

mosh는 원격 접속 시 비로그인 셸(non-login shell)을 실행하므로, `.zprofile`이 아닌 `.zshenv`에 brew 환경을 설정해야 합니다.

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshenv
```

## 기본 사용법

| 기능 | 명령어 |
|---|---|
| 원격 접속 | `mosh user@host` |
| 포트 지정 | `mosh --ssh="ssh -p 2222" user@host` |
| tmux 연결 | `mosh user@host -- tmux attach -t main` |
