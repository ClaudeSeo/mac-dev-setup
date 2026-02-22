# macOS 개발 환경 설정

효율적인 macOS 개발 환경을 자동으로 구성하기 위한 설정 저장소입니다.

[![macOS](https://img.shields.io/badge/macOS-15+-000000?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Shell](https://img.shields.io/badge/Shell-Zsh-1f425f?style=for-the-badge&logo=gnubash)](https://zsh.org/)
[![Homebrew](https://img.shields.io/badge/Homebrew-Latest-FBB040?style=for-the-badge&logo=homebrew)](https://brew.sh/)
[![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](LICENSE)

## 빠른 시작

1. Xcode Command Line Tools를 설치합니다.
   ```bash
   xcode-select --install
   ```
2. 저장소를 클론합니다.
   ```bash
   git clone https://github.com/ClaudeSeo/mac-dev-setup
   cd mac-dev-setup
   ```
3. 자동 설정 스크립트를 실행합니다.
   ```bash
   ./init.sh
   ```

## 명령어 참조

### 파일 시스템 및 탐색

| 기능 | 명령어 | 도구 | 설명 |
| --- | --- | --- | --- |
| 향상된 ls | `l` | [eza](https://github.com/eza-community/eza) | 컬러 파일 목록 출력 (옵션: `-abghHliS`) |
| 파일 검색 | `fd` | [fd](https://github.com/sharkdp/fd) | `find`보다 빠르고 간단한 파일 검색 |
| 트리 구조 | `tree` | [eza](https://github.com/eza-community/eza) | `node_modules` 제외 트리 구조 표시 |
| 디렉터리 점프 | `z` | [zoxide](https://github.com/ajeetdsouza/zoxide) | 자주 방문한 디렉터리로 빠르게 이동 |

### 파일 내용 조회 및 검색

| 기능 | 명령어 | 도구 | 설명 |
| --- | --- | --- | --- |
| 향상된 cat | `bat` | [bat](https://github.com/sharkdp/bat) | 문법 강조와 Git 통합이 포함된 `cat` |
| 텍스트 검색 | `rg` | [ripgrep](https://github.com/BurntSushi/ripgrep) | 매우 빠른 텍스트 검색 |
| 퍼지 파인더 | `fzf` | [fzf](https://github.com/junegunn/fzf) | 명령행 퍼지 검색 |

### 프로세스 관리

| 기능 | 명령어 | 도구 | 설명 |
| --- | --- | --- | --- |
| 향상된 ps | `procs` | [procs](https://github.com/dalance/procs) | 현대적인 프로세스 뷰어 |
| 실시간 모니터링 | `watch` | [watch](https://gitlab.com/procps-ng/procps) | 명령 실행 결과를 주기적으로 갱신 |
| 포트 킬 | `killport` | [killport](https://github.com/jkfran/killport) | 특정 포트를 사용하는 프로세스 종료 |

### 개발 도구

| 기능 | 명령어 | 도구 | 설명 |
| --- | --- | --- | --- |
| Git 향상 | `gh` | [GitHub CLI](https://github.com/cli/cli) | GitHub 공식 CLI |
| Git UI | `tig` | [tig](https://github.com/jonas/tig) | Git용 텍스트 모드 인터페이스 |
| 터미널 멀티플렉서 | `tmux` | [tmux](https://github.com/tmux/tmux) | 터미널 세션 관리 |
| Shell 검사 | `shellcheck` | [ShellCheck](https://github.com/koalaman/shellcheck) | 셸 스크립트 정적 분석 |
| JSON 처리 | `jq` | [jq](https://github.com/jqlang/jq) | 명령줄 JSON 프로세서 |
| YAML 처리 | `yq` | [yq](https://github.com/mikefarah/yq) | 명령줄 YAML 프로세서 |
| Dockerfile 린터 | `hadolint` | [Hadolint](https://github.com/hadolint/hadolint) | Dockerfile 베스트 프랙티스 검사 |
| AI 코딩 도구 | `opencode` | [OpenCode](https://github.com/AnomalyCo/opencode) | 터미널 기반 AI 코딩 어시스턴트 |

### Kubernetes 도구

| 기능 | 명령어 | 도구 | 설명 |
| --- | --- | --- | --- |
| Kubernetes CLI | `k` | [kubectl](https://kubernetes.io/docs/reference/kubectl/) | Kubernetes 클러스터 관리 |
| K8s 대시보드 | `k9s` | [k9s](https://github.com/derailed/k9s) | 터미널 기반 Kubernetes UI |
| 컨텍스트 전환 | `kubectx` | [kubectx](https://github.com/ahmetb/kubectx) | 컨텍스트 및 네임스페이스 전환 |
| 로그 추적 | `kubetail` | [kubetail](https://github.com/johanhaleby/kubetail) | 여러 Pod 로그 동시 추적 |
| 포트 포워딩 | `kubefwd` | [kubefwd](https://github.com/txn2/kubefwd) | 여러 서비스 동시 포트 포워딩 |
| EKS 관리 | `eksctl` | [eksctl](https://github.com/weaveworks/eksctl) | Amazon EKS 클러스터 관리 |
| EKS 노드 뷰어 | `eks-node-viewer` | [eks-node-viewer](https://github.com/awslabs/eks-node-viewer) | EKS 노드 시각화 |
| Helm | `helm` | [Helm](https://github.com/helm/helm) | Kubernetes 패키지 매니저 |

### 언어별 도구

| 기능 | 명령어 | 도구 | 설명 |
| --- | --- | --- | --- |
| Node.js 관리 | `fnm` | [fnm](https://github.com/Schniz/fnm) | 빠른 Node.js 버전 매니저 |
| 런타임 관리 | `mise` | [mise](https://github.com/jdx/mise) | Node, Python 등 런타임 버전 관리 |
| Python 패키지 관리 | `uv` | [uv](https://github.com/astral-sh/uv) | 빠른 Python 패키지 관리자 |
| Terraform 관리 | `tfenv` | [tfenv](https://github.com/tfutils/tfenv) | Terraform 버전 관리 |
| SDK 관리 | `sdk` | [SDKMAN!](https://github.com/sdkman/sdkman-cli) | Java, Kotlin 등 SDK 버전 관리 |
| JavaScript 런타임 | `bun` | [Bun](https://github.com/oven-sh/bun) | 빠른 JavaScript 런타임 및 패키지 매니저 |

### 네트워크 및 API

| 기능 | 명령어 | 도구 | 설명 |
| --- | --- | --- | --- |
| 네트워크 진단 | `trip` | [trippy](https://github.com/fujiapple852/trippy) | 현대적인 traceroute 도구 |

### 클라우드 및 서비스

| 기능 | 명령어 | 도구 | 설명 |
| --- | --- | --- | --- |
| MongoDB Atlas | `atlas` | [MongoDB Atlas CLI](https://github.com/mongodb/mongodb-atlas-cli) | MongoDB Atlas 관리 |
| MongoDB 도구 | `mongodump`, `mongorestore` | [MongoDB Database Tools](https://github.com/mongodb/mongo-tools) | MongoDB 데이터베이스 유틸리티 |
| Confluent | `cf` | [Confluent CLI](https://github.com/confluentinc/cli) | Apache Kafka 관리 (Confluent) |
| Infisical | `infisical` | [Infisical](https://github.com/Infisical/infisical) | 시크릿 관리 |

### 보안 도구

| 기능 | 명령어 | 도구 | 설명 |
| --- | --- | --- | --- |
| 시크릿 스캐닝 | `trufflehog` | [TruffleHog](https://github.com/trufflesecurity/trufflehog) | Git 히스토리에서 민감 정보 탐지 |
| 취약점 스캐닝 | `trivy` | [Trivy](https://github.com/aquasecurity/trivy) | 컨테이너/IaC 보안 취약점 스캐너 |

### 환경 및 설정

| 기능 | 명령어 | 도구 | 설명 |
| --- | --- | --- | --- |
| 환경 변수 관리 | `direnv` | [direnv](https://github.com/direnv/direnv) | 디렉터리별 환경 변수 자동 로드 |
| 유틸리티 툴킷 | `ut` | [ut](https://github.com/ksdme/ut) | 개발자용 다목적 CLI 유틸리티 (시간/인코딩 등) |
| 터미널 설정 | `ghostty` | [Ghostty](https://ghostty.org/) | 빠르고 현대적인 GPU 가속 터미널 |

### 사용자 정의 별칭

| 기능 | 명령어 | 도구 | 설명 |
| --- | --- | --- | --- |
| NPM 스크립트 실행 | `npmr` | `npm run` + `fzf` | `package.json` 스크립트를 `fzf`로 선택 실행 |
| Claude Monitor | `cm` | `claude-monitor` | Asia/Seoul 타임존으로 모니터링 |

## 권장 응용프로그램

아래 애플리케이션들은 Brewfile에 포함되어 있지 않아 직접 설치가 필요합니다.

<details>
<summary><strong>개발 도구</strong></summary>

- **Visual Studio Code**: [공식 다운로드](https://code.visualstudio.com/download)
- **OrbStack**: [공식 다운로드](https://orbstack.dev/download)
- **NoSQLBooster**: [공식 다운로드](https://nosqlbooster.com/downloads)
- **MongoDB Compass**: [공식 다운로드](https://www.mongodb.com/products/compass)
- **DBeaver**: [공식 다운로드](https://dbeaver.io/download/)
- **Redis Insight**: [공식 다운로드](https://redis.com/redis-insight/)

</details>

<details>
<summary><strong>브라우저 및 생산성 도구</strong></summary>

- **Arc Browser**: [공식 다운로드](https://arc.net/download)
- **Notion**: [공식 다운로드](https://www.notion.so/desktop)
- **Perplexity AI**: [공식 다운로드](https://www.perplexity.ai/platforms)

</details>

<details>
<summary><strong>유틸리티</strong></summary>

- **Tailscale**: [공식 다운로드](https://tailscale.com/download/macos)
- **AppCleaner**: [공식 다운로드](https://freemacsoft.net/appcleaner/)
- **Raycast**: [공식 다운로드](https://www.raycast.com/)
- **Excalidraw**: [웹 앱](https://excalidraw.com) - 손으로 그린 다이어그램

</details>

## 저장소 구조

주요 디렉터리와 설정은 다음과 같이 구성되어 있습니다.

- `init.sh`: 초기 설정 자동화 스크립트
- `brew/`, `zsh/`, `tmux/`, `nvim/`: 개발 환경별 설정
- `ghostty/`, `starship/`, `git/`, `zed/`: 터미널/에디터/도구 설정
