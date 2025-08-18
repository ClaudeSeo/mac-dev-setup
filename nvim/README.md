# 🚀 Neovim 설정

> 효율적인 개발을 위한 현대적인 Neovim 설정

## 📦 설치된 플러그인

### 🎨 UI & 테마
- **[vim-airline](https://github.com/vim-airline/vim-airline)** - 상태 바 및 탭라인
- **[vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)** - Airline 테마 컬렉션
- **[gruvbox](https://github.com/morhetz/gruvbox)** - 기본 컬러 스킴
- **[catppuccin](https://github.com/catppuccin/nvim)** - 현대적인 테마 (airline 테마로 사용)
- **[vim-snazzy](https://github.com/connorholyday/vim-snazzy)** - 추가 컬러 스킴
- **[indentLine](https://github.com/Yggdroot/indentLine)** - 들여쓰기 가이드라인

### 📁 파일 탐색 & 검색
- **[fzf](https://github.com/junegunn/fzf)** - 퍼지 파인더 (기본 설치)
- **[fzf.vim](https://github.com/junegunn/fzf.vim)** - Neovim FZF 통합
- **[NERDTree](https://github.com/preservim/nerdtree)** - 파일 트리 탐색기
- **[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)** - 향상된 파일 찾기 도구

### 🔧 개발 도구
- **[coc.nvim](https://github.com/neoclide/coc.nvim)** - IntelliSense 엔진 (자동완성, LSP)
- **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)** - 향상된 구문 강조
- **[vim-polyglot](https://github.com/sheerun/vim-polyglot)** - 다양한 언어 지원
- **[editorconfig-vim](https://github.com/editorconfig/editorconfig-vim)** - EditorConfig 지원

### 🐍 Python 개발 지원
- **[python-syntax](https://github.com/vim-python/python-syntax)** - 향상된 Python 구문 강조
- **[vim-python-pep8-indent](https://github.com/Vimjas/vim-python-pep8-indent)** - PEP8 들여쓰기 지원
- **[jedi-vim](https://github.com/davidhalter/jedi-vim)** - Python 자동 완성

### 🌿 Git 통합
- **[vim-fugitive](https://github.com/tpope/vim-fugitive)** - Git 명령어 통합
- **[gv.vim](https://github.com/junegunn/gv.vim)** - Git 커밋 브라우저
- **[blamer.nvim](https://github.com/APZelos/blamer.nvim)** - Git blame 표시
- **[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)** - 최신 Git 통합
- **[vim-gitgutter](https://github.com/airblade/vim-gitgutter)** - Git diff 표시
- **[committia.vim](https://github.com/rhysd/committia.vim)** - 커밋 메시지 작성 도움

### ⚡ 편의 기능
- **[vim-smoothie](https://github.com/psliwka/vim-smoothie)** - 부드러운 스크롤
- **[which-key.nvim](https://github.com/folke/which-key.nvim)** - 키 바인딩 도움말
- **[nvim-autopairs](https://github.com/windwp/nvim-autopairs)** - 자동 괄호 완성
- **[vim-commentary](https://github.com/tpope/vim-commentary)** - 코멘트 토글
- **[vim-better-whitespace](https://github.com/ntpeters/vim-better-whitespace)** - 공백 관리
- **[nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua)** - 색상 코드 하이라이팅

### 🔗 의존성
- **[plenary.nvim](https://github.com/nvim-lua/plenary.nvim)** - 다른 플러그인의 종속성

---

## ⌨️ 키맵 가이드

### 🔄 자동완성 (CoC.nvim)
| 키 | 기능 |
|---|---|
| `Tab` | 다음 완성 항목 선택 / 일반 탭 |
| `Shift+Tab` | 이전 완성 항목 선택 |
| `Ctrl+Space` | 강제 자동완성 트리거 |
| `Enter` | 선택된 항목 적용 |
| `Ctrl+j` / `Ctrl+k` | 완성 목록 탐색 (펌프 메뉴) |

### 🧭 코드 탐색 (CoC.nvim)
| 키 | 기능 |
|---|---|
| `gd` | 정의로 이동 (Go to Definition) |
| `gy` | 타입 정의로 이동 |
| `gi` | 구현으로 이동 |
| `gr` | 참조 찾기 |
| `gb` | 이전 위치로 돌아가기 |
| `[g` | 이전 진단으로 이동 |
| `]g` | 다음 진단으로 이동 |
| `<leader>d` | 문서/도움말 표시 |
| `<leader>rn` | 심볼 이름 바꾸기 |
| `<leader>f` | 선택된 코드 포맷팅 |
| `<leader>l` | ESLint 자동 수정 |

### 📂 버퍼 관리
| 키 | 기능 |
|---|---|
| `Tab Tab` | 이전 버퍼로 전환 |
| `<leader>T` | 새 버퍼 생성 |
| `<leader>bq` | 현재 버퍼 닫기 (이전 버퍼로 이동) |

### 🔍 파일 검색 (FZF)
| 키 | 기능 |
|---|---|
| `<leader><Tab>` | 파일 검색 |
| `<leader><leader><Tab>` | 파일 검색 (전체화면) |
| `<leader>q` | 버퍼 목록 |
| `<leader><leader>q` | 버퍼 목록 (전체화면) |
| `<leader>r` | 텍스트 검색 (Ripgrep) |
| `<leader><leader>r` | 텍스트 검색 (전체화면) |

#### FZF 내부 단축키
| 키 | 기능 |
|---|---|
| `Ctrl+t` | 새 탭에서 열기 |
| `Ctrl+x` | 수평 분할로 열기 |
| `Ctrl+v` | 수직 분할로 열기 |

### 🌳 파일 트리 (NERDTree)
| 키 | 기능 |
|---|---|
| `Ctrl+n` | NERDTree 토글 |
| `Ctrl+n Ctrl+r` | NERDTree 새로고침 및 포커스 |

### 🖥️ 터미널
| 키 | 기능 |
|---|---|
| `Ctrl+t` | 하단에 터미널 열기 |
| `<leader>Esc` | 터미널 모드에서 노멀 모드로 전환 |

### 📋 클립보드
| 키 | 기능 |
|---|---|
| `Ctrl+c` | 선택된 텍스트를 시스템 클립보드로 복사 (비주얼 모드) |

### 🔦 기타
| 키 | 기능 |
|---|---|
| `, Space` | 검색 하이라이트 제거 |
| `Ctrl+c` | Insert 모드에서 Escape (Insert 모드) |

---

## ⚙️ 주요 설정

### 📊 일반 설정
- **라인 넘버**: 절대 + 상대 라인 넘버 표시
- **마우스 지원**: 모든 모드에서 마우스 사용 가능
- **클립보드**: 시스템 클립보드와 연동
- **업데이트 타임**: 300ms (빠른 반응)
- **컬러 컬럼**: 80자 위치에 가이드라인 표시
- **인코딩**: UTF-8 지원

### 🎨 테마 & UI
- **기본 테마**: Gruvbox
- **Airline 테마**: Catppuccin
- **파워라인 폰트**: 활성화
- **들여쓰기 가이드**: 표시
- **Git Blamer**: 비활성화 (수동 토글)

### 📁 파일별 설정
| 파일 타입 | 탭 크기 | 컬러 컬럼 |
|---|---|---|
| TypeScript/JavaScript | 2 | 120 |
| Python | 4 | 80 |
| YAML/Ruby/JSON/SQL | 2 | 80 |
| HTML | 4 | 80 |

### 🚫 무시 파일 (NERDTree)
- `node_modules/`
- `*.pyc`
- `__pycache__/`

---

## 🔧 TreeSitter 언어 지원
자동 설치되는 언어:
- Python
- JavaScript
- TypeScript
- JSON
- YAML
- Bash
- Lua
- Vim

---

## 💡 사용 팁

1. **Leader 키**: 일반적으로 `\` 키 (설정에서 변경 가능)
2. **CoC 확장**: `:CocInstall` 명령으로 추가 언어 서버 설치 가능
3. **플러그인 설치**: `:PlugInstall` 명령으로 새 플러그인 설치
4. **설정 새로고침**: `:source %` 또는 Neovim 재시작
5. **Git Blamer 토글**: 기본적으로 비활성화, 필요시 수동으로 토글

