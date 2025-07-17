# macOS 개발 환경 설정 (2025년 4월 21일 기준)

이 레포지토리는 macOS 개발 환경 설정을 위한 가이드와 도구를 제공합니다.

## 간편 설정

이 레포지토리의 스크립트를 사용하여 모든 설정을 자동화할 수 있습니다:

```sh
# Xcode Command Line Tools 설치
$ xcode-select --install

# 레포지토리 클론 및 설정 스크립트 실행
$ git clone https://github.com/ClaudeSeo/mac-dev-setup
$ cd mac-dev-setup
$ ./init.sh
```

## 주요 구성 요소

### 시스템 설정

**숨김 파일 및 DS_Store 관리**

```sh
# 숨김 파일 보기
$ defaults write com.apple.finder AppleShowAllFiles -bool true

# .DS_Store 생성 방지
$ defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
```

### 개발 환경

**Homebrew**

- 모든 패키지는 `brew/Brewfile`에 정의되어 있으며 `brew bundle` 명령으로 한 번에 설치됩니다

**Shell 환경**

- zsh + Oh My Zsh 기본 구성

**개발 언어 관리**

- Node.js: fnm (Fast Node Manager)
- Python: pyenv + Poetry

### 주요 도구

- **Warp**: 현대적인 터미널 (Rust 기반)
- **Neovim**: 고급 텍스트 에디터 (설정: nvim/init.vim)
- **개발 생산성 도구**: bat, eza, fd, fzf, ripgrep
- **Kubernetes**: k9s, kubectl, kubectx
- **API/데이터 도구**: jq, yq, mitmproxy

### 권장 응용프로그램

Brewfile에 포함되어 있지 않은 추가 응용프로그램들은 아래 공식 홈페이지에서 다운로드할 수 있습니다:

**개발 도구**

- Visual Studio Code: [공식 다운로드](https://code.visualstudio.com/download)
- OrbStack: [공식 다운로드](https://orbstack.dev/download)
- NoSQLBooster: [공식 다운로드](https://nosqlbooster.com/downloads)
- MongoDB Compass: [공식 다운로드](https://www.mongodb.com/products/compass)
- DBeaver: [공식 다운로드](https://dbeaver.io/download/)
- Redis Insight: [공식 다운로드](https://redis.com/redis-insight/)

**브라우저 및 생산성 도구**

- Arc Browser: [공식 다운로드](https://arc.net/download)
- Notion: [공식 다운로드](https://www.notion.so/desktop)
- Obsidian: [공식 다운로드](https://obsidian.md/download)
- Perplexity AI: [공식 다운로드](https://www.perplexity.ai/platforms)
- TickTick: [공식 다운로드](https://ticktick.com/about/download)

**유틸리티**

- Tailscale: [공식 다운로드](https://tailscale.com/download/macos)
- AppCleaner: [공식 다운로드](https://freemacsoft.net/appcleaner/)
- Warp: [공식 다운로드](https://www.warp.dev/download)
- Raycast: [공식 다운로드](https://www.raycast.com/)
- Excalidraw: [웹 앱](https://excalidraw.com) - 손으로 그린 다이어그램

## 터미널 명령어 참조

이 설정으로 사용할 수 있는 주요 터미널 명령어들입니다.

### 파일 시스템 및 탐색

| 기능          | 명령어         | 라이브러리 URL                              | 설명                                       |
| ------------- | -------------- | ------------------------------------------- | ------------------------------------------ |
| 향상된 ls     | `l` (alias)    | [eza](https://github.com/eza-community/eza) | 컬러풀한 파일 목록 (기본 옵션: -abghHliS)  |
| 파일 검색     | `fd`           | [fd](https://github.com/sharkdp/fd)         | find 명령어의 더 빠르고 사용하기 쉬운 대안 |
| 트리 구조     | `tree` (alias) | [eza](https://github.com/eza-community/eza) | node_modules 제외한 트리 구조 표시         |
| 디렉터리 점프 | `z`            | [z](https://github.com/rupa/z)              | 자주 방문하는 디렉터리로 빠른 이동         |

### 파일 내용 조회 및 검색

| 기능        | 명령어 | 라이브러리 URL                                   | 설명                              |
| ----------- | ------ | ------------------------------------------------ | --------------------------------- |
| 향상된 cat  | `bat`  | [bat](https://github.com/sharkdp/bat)            | 문법 강조와 Git 통합이 포함된 cat |
| 텍스트 검색 | `rg`   | [ripgrep](https://github.com/BurntSushi/ripgrep) | 매우 빠른 텍스트 검색 도구        |
| 퍼지 파인더 | `fzf`  | [fzf](https://github.com/junegunn/fzf)           | 명령행 퍼지 파인더                |

### 프로세스 관리

| 기능            | 명령어     | 라이브러리 URL                                 | 설명                               |
| --------------- | ---------- | ---------------------------------------------- | ---------------------------------- |
| 향상된 ps       | `procs`    | [procs](https://github.com/dalance/procs)      | 현대적인 프로세스 뷰어             |
| 실시간 모니터링 | `watch`    | [watch](https://gitlab.com/procps-ng/procps)   | 명령어 실행 결과를 주기적으로 갱신 |
| 포트 킬         | `killport` | [killport](https://github.com/jkfran/killport) | 특정 포트를 사용하는 프로세스 종료 |

### 개발 도구

| 기능              | 명령어       | 라이브러리 URL                                       | 설명                         |
| ----------------- | ------------ | ---------------------------------------------------- | ---------------------------- |
| Git 향상          | `gh`         | [GitHub CLI](https://github.com/cli/cli)             | GitHub 공식 CLI 도구         |
| Git UI            | `tig`        | [tig](https://github.com/jonas/tig)                  | Git용 텍스트 모드 인터페이스 |
| 터미널 멀티플렉서 | `tm` (alias) | [tmux](https://github.com/tmux/tmux)                 | 터미널 세션 관리             |
| Shell 검사        | `shellcheck` | [ShellCheck](https://github.com/koalaman/shellcheck) | 셸 스크립트 정적 분석 도구   |
| JSON 처리         | `jq`         | [jq](https://github.com/jqlang/jq)                   | 명령줄 JSON 프로세서         |
| YAML 처리         | `yq`         | [yq](https://github.com/mikefarah/yq)                | 명령줄 YAML 프로세서         |

### Kubernetes 도구

| 기능           | 명령어            | 라이브러리 URL                                                | 설명                                     |
| -------------- | ----------------- | ------------------------------------------------------------- | ---------------------------------------- |
| Kubernetes CLI | `k` (alias)       | [kubectl](https://kubernetes.io/docs/reference/kubectl/)      | Kubernetes 클러스터 관리                 |
| K8s 대시보드   | `k9s`             | [k9s](https://github.com/derailed/k9s)                        | 터미널 기반 Kubernetes UI                |
| 컨텍스트 전환  | `kubectx`         | [kubectx](https://github.com/ahmetb/kubectx)                  | Kubernetes 컨텍스트 및 네임스페이스 전환 |
| 로그 추적      | `kubetail`        | [kubetail](https://github.com/johanhaleby/kubetail)           | 여러 Pod의 로그를 동시에 추적            |
| 포트 포워딩    | `kubefwd`         | [kubefwd](https://github.com/txn2/kubefwd)                    | 여러 서비스 동시 포트 포워딩             |
| EKS 관리       | `eksctl`          | [eksctl](https://github.com/weaveworks/eksctl)                | Amazon EKS 클러스터 관리                 |
| EKS 노드 뷰어  | `eks-node-viewer` | [eks-node-viewer](https://github.com/awslabs/eks-node-viewer) | EKS 노드 시각화 도구                     |
| Helm           | `helm`            | [Helm](https://github.com/helm/helm)                          | Kubernetes 패키지 매니저                 |

### 언어별 도구

| 기능               | 명령어   | 라이브러리 URL                                    | 설명                                 |
| ------------------ | -------- | ------------------------------------------------- | ------------------------------------ |
| Node.js 관리       | `fnm`    | [fnm](https://github.com/Schniz/fnm)              | 빠른 Node.js 버전 매니저             |
| Python 관리        | `pyenv`  | [pyenv](https://github.com/pyenv/pyenv)           | Python 버전 관리                     |
| Python 패키징      | `poetry` | [Poetry](https://github.com/python-poetry/poetry) | 현대적인 Python 의존성 관리          |
| Python 패키지 관리 | `uv`     | [uv](https://github.com/astral-sh/uv)             | 매우 빠른 Python 패키지 관리자       |
| Terraform 관리     | `tfenv`  | [tfenv](https://github.com/tfutils/tfenv)         | Terraform 버전 관리                  |
| SDK 관리           | `sdk`    | [SDKMAN!](https://github.com/sdkman/sdkman-cli)   | 여러 SDK 버전 관리 (Java, Kotlin 등) |

### 네트워크 및 API

| 기능          | 명령어      | 라이브러리 URL                                      | 설명                               |
| ------------- | ----------- | --------------------------------------------------- | ---------------------------------- |
| HTTP 프록시   | `mitmproxy` | [mitmproxy](https://github.com/mitmproxy/mitmproxy) | HTTP/HTTPS 트래픽 인터셉트 및 수정 |
| VPN 터널      | `sshuttle`  | [sshuttle](https://github.com/sshuttle/sshuttle)    | SSH를 통한 VPN                     |
| 터널링        | `ngrok`     | [ngrok](https://github.com/inconshreveable/ngrok)   | 로컬 서버를 인터넷에 노출          |
| 네트워크 진단 | `trippy`    | [trippy](https://github.com/fujiapple852/trippy)    | 현대적인 traceroute 도구           |

### 클라우드 및 서비스

| 기능          | 명령어                      | 라이브러리 URL                                                    | 설명                          |
| ------------- | --------------------------- | ----------------------------------------------------------------- | ----------------------------- |
| MongoDB Atlas | `atlas`                     | [MongoDB Atlas CLI](https://github.com/mongodb/mongodb-atlas-cli) | MongoDB Atlas 관리            |
| MongoDB 도구  | `mongodump`, `mongorestore` | [MongoDB Database Tools](https://github.com/mongodb/mongo-tools)  | MongoDB 데이터베이스 유틸리티 |
| Confluent     | `cf` (alias)                | [Confluent CLI](https://github.com/confluentinc/cli)              | Apache Kafka 관리 (Confluent) |
| Infisical     | `infisical`                 | [Infisical](https://github.com/Infisical/infisical)               | 시크릿 관리                   |

### 환경 및 설정

| 기능           | 명령어   | 라이브러리 URL                             | 설명                           |
| -------------- | -------- | ------------------------------------------ | ------------------------------ |
| 환경 변수 관리 | `direnv` | [direnv](https://github.com/direnv/direnv) | 디렉터리별 환경 변수 자동 로드 |

### 사용자 정의 별칭 (Aliases)

| 기능              | 명령어 | 원본 명령어       | 설명                                        |
| ----------------- | ------ | ----------------- | ------------------------------------------- |
| NPM 스크립트 실행 | `npmr` | `npm run` + `fzf` | package.json 스크립트를 fzf로 선택하여 실행 |
| Claude Monitor    | `cm`   | `claude-monitor`  | Asia/Seoul 타임존으로 모니터링              |
| Claude Squad      | `cs`   | `claude-squad`    | Claude Squad 명령어 실행                    |
