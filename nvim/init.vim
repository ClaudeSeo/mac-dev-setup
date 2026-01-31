" General configuration
scriptencoding utf-8
set nocompatible
set termguicolors
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp949,korea,iso-2022-kr
set fileformat=unix backspace=2
set autoindent smartindent expandtab
set showcmd
set noeb vb t_vb=
set directory=/tmp
set autoread
set nobackup
set noswapfile
set hidden
set updatetime=300  " 더 빠른 반응을 위해 업데이트 시간 단축
set timeoutlen=500  " 키 조합 대기 시간 단축
set laststatus=2
set nofoldenable
set signcolumn=yes  " 항상 signcolumn 표시 (기호 열 유지)
set mouse=a         " 모든 모드에서 마우스 지원
set clipboard+=unnamedplus  " 시스템 클립보드 사용
" TreeSitter 사용 시 자동으로 비활성화됨 (Lua 설정 참조)
syntax on

" Line Number
set number
set relativenumber  " 상대적 줄 번호 표시
set cursorline

" Search
set ignorecase
set smartcase
set hlsearch
set nowrapscan
set incsearch

"Indents
set ts=4 sw=4 softtabstop=4 modeline
set colorcolumn=80

" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect

" Key Mapping
inoremap <expr> <C-j> ((pumvisible())?("\<C-n>"):("<C-j>"))
inoremap <expr> <Tab> ((pumvisible())?("\<C-n>"):("<Tab>"))
inoremap <expr> <S-Tab> ((pumvisible())?("\<C-p>"):("<S-Tab>"))
inoremap <expr> <C-k> ((pumvisible())?("\<C-p>"):("<C-k>"))
inoremap <C-c> <Esc>

" Buffer Navigations
nnoremap <silent> <leader>T :enew<CR>
nnoremap <silent> <leader>bq :bp <BAR> bd #<CR>

" Remove highlight
nnoremap <silent> ,<Space> :noh<CR>

" fzf
nnoremap <silent> <leader><Tab> :Files<CR>
nnoremap <silent> <leader><leader><Tab> :Files!<CR>
nnoremap <silent> <leader>q :Buffers<CR>
nnoremap <silent> <leader><leader>q :Buffers!<CR>
nnoremap <leader>R :Rg<space>
nnoremap <leader><leader>R :Rg!<space>

" Telescope (고급 검색 및 LSP 통합)
nnoremap <silent> <leader>ff :Telescope find_files<CR>
nnoremap <silent> <leader>fg :Telescope live_grep<CR>
nnoremap <silent> <leader>fb :Telescope buffers<CR>
nnoremap <silent> <leader>fh :Telescope help_tags<CR>
nnoremap <silent> <leader>fc :Telescope git_commits<CR>

" NERDTree
map <C-n> :NERDTreeToggle<CR>
nmap <C-n><C-r> :NERDTreeFocus<cr> \| R \| <c-w><c-p>

" Terminal
tnoremap <leader><Esc> <C-\><C-n>

" Clipboard
vmap <silent> <C-c> "*y

" Terminal
nnoremap <silent> <C-t> :bel sp 50 \| resize 10 \| terminal<CR>

" VSCode에서 실행 중인지 확인
let g:is_vscode = exists('g:vscode')

" VSCode 환경 전용 설정
if g:is_vscode
    " VSCode LSP 명령 매핑
    nmap <silent> gd <Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>
    nmap <silent> gD <Cmd>call VSCodeNotify('editor.action.peekDefinition')<CR>
    nmap <silent> gr <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>
    nmap <silent> gi <Cmd>call VSCodeNotify('editor.action.goToImplementation')<CR>
    nmap <silent> gy <Cmd>call VSCodeNotify('editor.action.goToTypeDefinition')<CR>
    nmap <silent> K <Cmd>call VSCodeNotify('editor.action.showHover')<CR>
    nmap <silent> <leader>rn <Cmd>call VSCodeNotify('editor.action.rename')<CR>
    nmap <silent> <leader>ca <Cmd>call VSCodeNotify('editor.action.quickFix')<CR>
    nmap <silent> [d <Cmd>call VSCodeNotify('editor.action.marker.prev')<CR>
    nmap <silent> ]d <Cmd>call VSCodeNotify('editor.action.marker.next')<CR>
    nmap <silent> <leader>f <Cmd>call VSCodeNotify('editor.action.formatDocument')<CR>

    " VSCode 편의 기능
    nmap <silent> <leader><Tab> <Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>
    nmap <silent> <leader>e <Cmd>call VSCodeNotify('workbench.view.explorer')<CR>
    nmap <silent> <C-n> <Cmd>call VSCodeNotify('workbench.view.explorer')<CR>

    " 주석 토글
    xmap <silent> gc <Cmd>call VSCodeNotify('editor.action.commentLine')<CR>
    nmap <silent> gcc <Cmd>call VSCodeNotify('editor.action.commentLine')<CR>
else
    " 일반 Neovim 환경 전용 설정
    nnoremap <silent> <Tab><Tab> :b #<CR>
    nmap <leader>d :call <SID>show_documentation()<CR>
endif

" 조건부 플러그인 로딩 헬퍼 함수 (VSCode-Neovim 지원)
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" Plugins
call plug#begin('~/.config/nvim/plugged')
" VSCode/일반 Neovim 공통 플러그인
Plug 'editorconfig/editorconfig-vim'
Plug 'psliwka/vim-smoothie'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'morhetz/gruvbox'
Plug 'rhysd/committia.vim'
Plug 'tpope/vim-commentary'

" VSCode에서 불필요한 플러그인 (조건부 로딩)
Plug 'vim-airline/vim-airline', Cond(!exists('g:vscode'))
Plug 'vim-airline/vim-airline-themes', Cond(!exists('g:vscode'))
Plug 'junegunn/fzf', Cond(!exists('g:vscode'), { 'dir': '~/.fzf', 'do': './install --all' })
Plug 'junegunn/fzf.vim', Cond(!exists('g:vscode'))
Plug 'APZelos/blamer.nvim', Cond(!exists('g:vscode'))
Plug 'Yggdroot/indentLine', Cond(!exists('g:vscode'))
Plug 'ntpeters/vim-better-whitespace', Cond(!exists('g:vscode'))
Plug 'preservim/nerdtree', Cond(!exists('g:vscode'))

" 최신 플러그인 (VSCode에서 불필요)
Plug 'nvim-lua/plenary.nvim', Cond(!exists('g:vscode'))
Plug 'nvim-treesitter/nvim-treesitter', Cond(!exists('g:vscode'), {'do': ':TSUpdate'})
Plug 'lewis6991/gitsigns.nvim', Cond(!exists('g:vscode'))
Plug 'nvim-telescope/telescope.nvim', Cond(!exists('g:vscode'), { 'tag': '0.1.2' })
Plug 'folke/which-key.nvim', Cond(!exists('g:vscode'))
Plug 'windwp/nvim-autopairs', Cond(!exists('g:vscode'))
Plug 'norcalli/nvim-colorizer.lua', Cond(!exists('g:vscode'))

" Python 개발 지원 (VSCode에서 불필요)
Plug 'vim-python/python-syntax', Cond(!exists('g:vscode'))
Plug 'Vimjas/vim-python-pep8-indent', Cond(!exists('g:vscode'))

" CoC - Language Server Protocol 지원 (VSCode에서 불필요)
" Python: :CocInstall coc-pyright 실행 필요
Plug 'neoclide/coc.nvim', Cond(!exists('g:vscode'), {'branch': 'release'})
call plug#end()

" 일반 Neovim 환경 전용 설정 (VSCode에서 실행 시 건너뜀)
if !exists('g:vscode')
    " NERDTree
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
    let NERDTreeShowHidden=1
    let g:NERDTreeMouseMode = 3
    let g:NERDTreeIgnore = ['^node_modules$', '\.pyc$', '^__pycache__$']

    " Coc Config
    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~ '\s'
    endfunction

    inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
    if has('nvim')
      inoremap <silent><expr> <c-space> coc#refresh()
    else
      inoremap <silent><expr> <c-@> coc#refresh()
    endif

    if exists('*complete_info')
      inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
    else
      inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    endif

    " CoC LSP 매핑
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)
    nmap <silent> gb <C-o>
    nmap <leader>L :CocCommand eslint.executeAutofix<CR>
    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      else
        call CocActionAsync('doHover')
      endif
    endfunction
    autocmd CursorHold * silent call CocActionAsync('highlight')
    nmap <leader>rn <Plug>(coc-rename)

    " fzf
    let g:fzf_action = {
        \     'ctrl-t': 'tab split',
        \     'ctrl-x': 'split',
        \     'ctrl-v': 'vsplit',
        \ }
    command! -bang -nargs=? -complete=dir Files
        \ call fzf#vim#files(
        \     <q-args>,
        \     fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}),
        \     <bang>0)
    command! -bang -nargs=* Rg
        \ call fzf#vim#grep(
        \     'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>),
        \     1,
        \     fzf#vim#with_preview(),
        \     <bang>0)

    " airline
    let g:airline_theme='gruvbox'
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#formatter = 'default'
    let g:airline#extensions#tabline#fnamemod = ':t'
    let g:airline_powerline_fonts = 1

    " git blamer
    let g:blamer_enabled = 0
    let g:blamer_delay = 500
endif

" editorconfig (공통 설정)
let g:EditorConfig_core_mode = 'external_command'
let g:EditorConfig_exec_path = '/usr/local/bin/editorconfig'

" 일반 Neovim 전용 설정 (테마, Lua 플러그인 등)
if !exists('g:vscode')
    " 테마 설정
    autocmd vimenter * colorscheme gruvbox

    " Python 구문 강조 옵션
    let g:python_highlight_all = 1

" Lua 플러그인 설정
lua <<EOF
-- 플러그인이 설치되어 있는지 확인 후 실행
local function plugin_exists(name)
  local ok, _ = pcall(require, name)
  return ok
end

-- TreeSitter 설정 (성능 최적화)
if plugin_exists('nvim-treesitter.configs') then
  require'nvim-treesitter.configs'.setup {
    ensure_installed = { "python", "javascript", "typescript", "json", "yaml", "bash", "lua", "vim" },
    highlight = {
      enable = true,
      -- TreeSitter 사용 시 기본 syntax 비활성화하여 성능 향상
      additional_vim_regex_highlighting = false,
    },
    -- 증분 선택 활성화
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<leader>ss",
        node_incremental = "<leader>sn",
        scope_incremental = "<leader>sc",
        node_decremental = "<leader>sm",
      },
    },
    -- 들여쓰기 지원
    indent = {
      enable = true
    }
  }
  -- TreeSitter가 활성화되면 syntax를 완전히 비활성화
  vim.cmd('syntax off')
end

-- GitSigns 설정
if plugin_exists('gitsigns') then
  require('gitsigns').setup({
    signs = {
      add          = { text = '│' },
      change       = { text = '│' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
  })
end

-- WhichKey 설정
if plugin_exists('which-key') then
  require("which-key").setup {
    plugins = {
      spelling = {
        enabled = true,
      },
    },
  }
end

-- Autopairs 설정
if plugin_exists('nvim-autopairs') then
  require('nvim-autopairs').setup{
    check_ts = true,  -- TreeSitter 통합
  }
end

-- Colorizer 설정
if plugin_exists('colorizer') then
  require('colorizer').setup()
end

-- Telescope 설정
if plugin_exists('telescope') then
  local telescope = require('telescope')
  local actions = require('telescope.actions')

  telescope.setup{
    defaults = {
      -- 기본 설정
      mappings = {
        i = {
          -- Insert 모드 키맵
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["<Esc>"] = actions.close,
        },
        n = {
          -- Normal 모드 키맵
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["q"] = actions.close,
        },
      },
      -- 프리뷰 설정
      layout_config = {
        horizontal = {
          preview_width = 0.55,
          results_width = 0.8,
        },
        vertical = {
          mirror = false,
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120,
      },
      -- 파일 무시 패턴
      file_ignore_patterns = {
        "node_modules",
        ".git/",
        "__pycache__",
        "%.pyc",
      },
    },
    pickers = {
      find_files = {
        theme = "dropdown",
        previewer = false,
      },
    },
  }
end
EOF
endif

" Filetype specific
filetype plugin indent on
au FileType typescript  setl ts=2 sw=2 sts=2 colorcolumn=120
au FileType typescriptreact  setl syntax=typescript ts=2 sw=2 sts=2 colorcolumn=120
au FileType javascript  setl ts=2 sw=2 sts=2 colorcolumn=120
au FileType yaml        setl ts=2 sw=2 sts=2
au FileType ruby        setl ts=2 sw=2 sts=2
au FileType html        setl ts=4 sw=4 sts=4
au FileType sql         setl ts=2 sw=2 sts=2
au FileType python      setl ts=4 sw=4 sts=4 completeopt-=preview
au FileType make        setl noet
au FileType json        setl ts=2 sw=2 sts=2
