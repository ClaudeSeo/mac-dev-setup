# 명령어 참조

> `brew/Brewfile`로 설치되는 CLI 도구와 `zsh/.zshrc.local`의 사용자 정의 별칭 목록입니다. ← [README](../README.md)


## 파일 시스템 및 탐색

| 기능 | 명령어 | 도구 | 설명 |
| --- | --- | --- | --- |
| 향상된 ls | `l` | [eza](https://github.com/eza-community/eza) | 컬러 파일 목록 출력 (옵션: `-abghHliS -s modified`) |
| 파일 검색 | `fd` | [fd](https://github.com/sharkdp/fd) | `find`보다 빠르고 간단한 파일 검색 |
| 트리 구조 | `tree` | [eza](https://github.com/eza-community/eza) | `node_modules` 제외 트리 구조 표시 |
| 디렉터리 점프 | `z` | [zoxide](https://github.com/ajeetdsouza/zoxide) | 자주 방문한 디렉터리로 빠르게 이동 |

## 파일 내용 조회 및 검색

| 기능 | 명령어 | 도구 | 설명 |
| --- | --- | --- | --- |
| 향상된 cat | `bat` | [bat](https://github.com/sharkdp/bat) | 문법 강조와 Git 통합이 포함된 `cat` |
| 텍스트 검색 | `rg` | [ripgrep](https://github.com/BurntSushi/ripgrep) | 매우 빠른 텍스트 검색 |
| 퍼지 파인더 | `fzf` | [fzf](https://github.com/junegunn/fzf) | 명령행 퍼지 검색 |

## 프로세스 관리

| 기능 | 명령어 | 도구 | 설명 |
| --- | --- | --- | --- |
| 향상된 ps | `procs` | [procs](https://github.com/dalance/procs) | 현대적인 프로세스 뷰어 |
| 실시간 모니터링 | `watch` | [watch](https://gitlab.com/procps-ng/procps) | 명령 실행 결과를 주기적으로 갱신 |
| 포트 킬 | `killport` | [killport](https://github.com/jkfran/killport) | 특정 포트를 사용하는 프로세스 종료 |

## 개발 도구

| 기능 | 명령어 | 도구 | 설명 |
| --- | --- | --- | --- |
| Git 향상 | `gh` | [GitHub CLI](https://github.com/cli/cli) | GitHub 공식 CLI |
| Git UI | `tig` | [tig](https://github.com/jonas/tig) | Git용 텍스트 모드 인터페이스 |
| Git worktree 관리 | `wt` | [Worktrunk](https://worktrunk.dev) | 병렬 AI 에이전트 작업용 worktree 생성과 전환 (Herdr 플러그인이 사용) |
| 터미널 멀티플렉서 | `tmux` | [tmux](https://github.com/tmux/tmux) | 터미널 세션 관리 |
| 에이전트 멀티플렉서 | `herdr` | [Herdr](https://herdr.dev) | AI 코딩 에이전트용 터미널 워크스페이스 관리 (키맵은 tmux와 동일) |
| 에이전트 모바일 연동 | `moshi` | [Moshi](https://getmoshi.app) | AI 코딩 에이전트를 모바일 앱과 연동하는 데몬 (호스트 페어링, tmux 런처, diff 뷰어 내장) |
| Shell 검사 | `shellcheck` | [ShellCheck](https://github.com/koalaman/shellcheck) | 셸 스크립트 정적 분석 |
| JSON 처리 | `jq` | [jq](https://github.com/jqlang/jq) | 명령줄 JSON 프로세서 |
| YAML 처리 | `yq` | [yq](https://github.com/mikefarah/yq) | 명령줄 YAML 프로세서 |
| Dockerfile 린터 | `hadolint` | [Hadolint](https://github.com/hadolint/hadolint) | Dockerfile 베스트 프랙티스 검사 |
| 토큰 최적화 프록시 | `rtk` | [RTK](https://github.com/rtk-ai/rtk)| Claude Code 토큰 사용량 절감 CLI 프록시 |
| 로컬 LLM | `ollama` | [Ollama](https://github.com/ollama/ollama) | 로컬 대규모 언어 모델 실행 |

## Kubernetes 도구

| 기능 | 명령어 | 도구 | 설명 |
| --- | --- | --- | --- |
| Kubernetes CLI | `k` | [kubectl](https://kubernetes.io/docs/reference/kubectl/) | Kubernetes 클러스터 관리 |
| K8s 대시보드 | `k9s` | [k9s](https://github.com/derailed/k9s) | 터미널 기반 Kubernetes UI |
| 컨텍스트 전환 | `kubectx` | [kubectx](https://github.com/ahmetb/kubectx) | 컨텍스트 및 네임스페이스 전환 |
| 로그 추적 | `kubetail` | [kubetail](https://github.com/johanhaleby/kubetail) | 여러 Pod 로그 동시 추적 |
| 포트 포워딩 | `kubefwd` | [kubefwd](https://github.com/txn2/kubefwd) | 여러 서비스 동시 포트 포워딩 |
| EKS 관리 | `eksctl` | [eksctl](https://github.com/eksctl-io/eksctl) | Amazon EKS 클러스터 관리 |
| EKS 노드 뷰어 | `eks-node-viewer` | [eks-node-viewer](https://github.com/awslabs/eks-node-viewer) | EKS 노드 시각화 |
| Helm | `helm` | [Helm](https://github.com/helm/helm) | Kubernetes 패키지 매니저 |

## 언어별 도구

| 기능 | 명령어 | 도구 | 설명 |
| --- | --- | --- | --- |
| Node.js 관리 | `fnm` | [fnm](https://github.com/Schniz/fnm) | 빠른 Node.js 버전 매니저 |
| 런타임 관리 | `mise` | [mise](https://github.com/jdx/mise) | Node, Python 등 런타임 버전 관리 |
| Python 패키지 관리 | `uv` | [uv](https://github.com/astral-sh/uv) | 빠른 Python 패키지 관리자 |
| Terraform 관리 | `tfenv` | [tfenv](https://github.com/tfutils/tfenv) | Terraform 버전 관리 |
| SDK 관리 | `sdk` | [SDKMAN!](https://github.com/sdkman/sdkman-cli) | Java, Kotlin 등 SDK 버전 관리 |
| JavaScript 런타임 | `bun` | [Bun](https://github.com/oven-sh/bun) | 빠른 JavaScript 런타임 및 패키지 매니저 |

## 네트워크 및 API

| 기능 | 명령어 | 도구 | 설명 |
| --- | --- | --- | --- |
| 네트워크 진단 | `trip` | [trippy](https://github.com/fujiapple852/trippy) | 현대적인 traceroute 도구 |
| gRPC 클라이언트 | `grpcurl` | [grpcurl](https://github.com/fullstorydev/grpcurl) | gRPC 서비스용 curl |
| 모바일 셸 | `mosh` | [Mosh](https://github.com/mobile-shell/mosh) | 로밍 지원 원격 터미널 (SSH 대체) |

## 클라우드 및 서비스

| 기능 | 명령어 | 도구 | 설명 |
| --- | --- | --- | --- |
| MongoDB Atlas | `atlas` | [MongoDB Atlas CLI](https://github.com/mongodb/mongodb-atlas-cli) | MongoDB Atlas 관리 |
| MongoDB 도구 | `mongodump`, `mongorestore` | [MongoDB Database Tools](https://github.com/mongodb/mongo-tools) | MongoDB 데이터베이스 유틸리티 |
| Confluent | `confluent` | [Confluent CLI](https://github.com/confluentinc/cli) | Apache Kafka 관리 (Confluent) |
| Infisical | `infisical` | [Infisical](https://github.com/Infisical/infisical) | 시크릿 관리 |

## 보안 도구

| 기능 | 명령어 | 도구 | 설명 |
| --- | --- | --- | --- |
| 시크릿 스캐닝 | `trufflehog` | [TruffleHog](https://github.com/trufflesecurity/trufflehog) | Git 히스토리에서 민감 정보 탐지 |
| 취약점 스캐닝 | `trivy` | [Trivy](https://github.com/aquasecurity/trivy) | 컨테이너/IaC 보안 취약점 스캐너 |

## 환경 및 설정

| 기능 | 명령어 | 도구 | 설명 |
| --- | --- | --- | --- |
| 환경 변수 관리 | `direnv` | [direnv](https://github.com/direnv/direnv) | 디렉터리별 환경 변수 자동 로드 |
| Mac 정리 | `mole` | [Mole](https://mole.fit) | Mac 딥 클린 및 최적화 (AppCleaner 대체) |
| 유틸리티 툴킷 | `ut` | [ut](https://github.com/ksdme/ut) | 개발자용 다목적 CLI 유틸리티 (시간/인코딩 등) |
| 터미널 설정 | `ghostty` | [Ghostty](https://ghostty.org/) | 빠르고 현대적인 GPU 가속 터미널 |

## 사용자 정의 별칭

| 기능 | 명령어 | 도구 | 설명 |
| --- | --- | --- | --- |
| NPM 스크립트 실행 | `npmr` | `npm run` + `fzf` | `package.json` 스크립트를 `fzf`로 선택 실행 |
| Tmux 메인 세션 | `tm` | `tmux new-session -A -s main` | `main` 세션에 접속하거나 없으면 생성 |
| Herdr 단축 | `hr` | `herdr` | Herdr 실행 |
| Claude Code 자동 승인 | `cca` | `claude --dangerously-skip-permissions` | 권한 확인 없이 Claude Code 실행 |
| Claude 계정 전환 | `ccm` | `abc cc account` | Claude Code 계정 관리 |
| Codex 자동 승인 | `coa` | `codex --yolo` | 권한 확인 없이 Codex 실행 |
| Kiro 채팅 | `ki` | `kiro-cli chat -a --v3` | Kiro CLI 채팅 세션 |
| GNU timeout | `timeout` | `gtimeout` (coreutils) | GNU `timeout`으로 대체 |

## 그 밖의 Brewfile 항목

위 표에 없는 나머지 항목입니다. 설명은 `brew/Brewfile`의 주석을 따릅니다.

| 항목 | 종류 | 설명 |
|---|---|---|
| `awscli` | brew | AWS 명령줄 인터페이스 |
| `ast-grep` | brew | 코드 구조 검색, 린트, 재작성 |
| `coreutils` | brew | GNU 파일, 셸, 텍스트 유틸리티 (`gtimeout` 등) |
| `docker`, `docker-compose` | brew | 컨테이너 실행과 Compose |
| `container`, `container-compose` | brew | Apple Container(경량 VM 기반 Linux 컨테이너)와 Compose 호환 도구 |
| `socktainer/tap/socktainer-next` | brew | Apple Container 위의 Docker 호환 REST API |
| `duckdb` | brew | 임베디드 SQL OLAP 데이터베이스 |
| `jsongrep` | brew | JSON, YAML, TOML 등 구조화 문서 질의 도구 |
| `snzip` | brew | snappy 기반 압축/해제 도구 |
| `mongocli` | brew | MongoDB 클라우드 관리 CLI |
| `tailscale` | brew | WireGuard 기반 VPN 클라이언트 |
| `git`, `zsh`, `neovim`, `starship`, `tree` | brew | 기본 도구 (설정은 이 저장소가 관리) |
| `zsh-autosuggestions`, `zsh-completions`, `zsh-syntax-highlighting` | brew | Zsh 자동 제안, 추가 completion, 문법 강조 (`.zshrc.local`에서 로드) |
| `can1357/tap/omp` | brew | IDE 연동 코딩 에이전트 |
| `codex` | cask | OpenAI Codex 터미널 코딩 에이전트 (별칭 `coa`) |
| `paseo` | cask | AI 코딩 에이전트용 셀프 호스팅 데몬 |
| `1password-cli@beta` | cask | 1Password 명령줄 도우미 |
| `obsidian` | cask | 로컬 Markdown 폴더 기반 지식 베이스 |
| `font-hack-nerd-font`, `font-d2coding` | cask | Ghostty 폰트 (Hack Nerd Font Mono, D2Coding) |
| `postmelee/tap/alhangeul` | cask | (Brewfile에 설명 없음) |
