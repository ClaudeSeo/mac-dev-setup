" General configuration
scriptencoding utf-8
set nocompatible
set termguicolors
set encoding=utf-8
set fileencoding=utf-8
set fileformat=unix backspace=2
set autoindent smartindent expandtab
set showcmd
set encoding=utf-8 fileencodings=ucs-bom,utf-8,cp949,korea,iso-2022-kr
set noeb vb t_vb=
set directory=/tmp
set autoread
set nobackup
set noswapfile
set hidden
set updatetime=1500
set laststatus=2
set nofoldenable
syntax on

" Line Number
set number
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
inoremap <expr> <S-Tab> ((pumvisible())?("\<C-p>"):("\<S-Tab>"))
inoremap <expr> <C-k> ((pumvisible())?("\<C-p>"):("<C-k>"))
inoremap <C-c> <Esc>

" Buffer Navigations
nnoremap <silent> <Tab><Tab> :b #<CR>
nnoremap <silent> <leader>T :enew<CR>
nnoremap <silent> <leader>bq :bp <BAR> bd #<CR>

" Remove highlight
nnoremap <silent> ,<Space> :noh<CR>

" fzf
nnoremap <silent> <leader><Tab> :Files<CR>
nnoremap <silent> <leader><leader><Tab> :Files!<CR>
nnoremap <silent> <leader>q :Buffers<CR>
nnoremap <silent> <leader><leader>q :Buffers!<CR>
nnoremap <leader>r :Rg<space>
nnoremap <leader><leader>r :Rg!<space>

" NERDTree
map <C-n> :NERDTreeToggle<CR>
nmap <C-n><C-r> :NERDTreeFocus<cr> \| R \| <c-w><c-p>

" Terminal
tnoremap <leader><Esc> <C-\><C-n>

" Clipboard
vmap <silent> <C-c> "*y

" Terminal
nnoremap <silent> <C-t> :bel sp 50 \| resize 10 \| terminal<CR>

" Plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'editorconfig/editorconfig-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'psliwka/vim-smoothie'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'sheerun/vim-polyglot'
Plug 'APZelos/blamer.nvim'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'Yggdroot/indentLine'
Plug 'connorholyday/vim-snazzy'
Plug 'morhetz/gruvbox'
Plug 'ntpeters/vim-better-whitespace'
Plug 'preservim/nerdtree'

Plug 'tpope/vim-fugitive'
Plug 'rhysd/committia.vim'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'Shougo/denite.nvim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
let NERDTreeShowHidden=1
set mouse=a
let g:NERDTreeMouseMode = 3

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

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>d  :call <SID>show_documentation()<CR>
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


" eidtorconfig
let g:EditorConfig_core_mode = 'external_command'
let g:EditorConfig_exec_path = '/usr/local/bin/editorconfig'

" airline
let g:airline_theme='onedark'
let g:airline#extensions#tabline#enabled = 1 " Enable the list of buffers
let g:airline#extensions#tabline#fnamemod = ':t' " Show just the filename

" git blamer
let g:blamer_enabled = 0
let g:blamer_delay = 500

autocmd vimenter * colorscheme gruvbox

" Filetype specific
filetype plugin indent on
au FileType typescript  setl ts=2 sw=2 sts=2 colorcolumn=120
au FileType typescriptreact  setl syntax=typescript ts=2 sw=2 sts=2 colorcolumn=120
au FileType javascript  setl ts=2 sw=2 sts=2 colorcolumn=120
au FileType yaml        setl ts=2 sw=2 sts=2
au FileType ruby        setl ts=2 sw=2 sts=2
au FileType yaml        setl ts=2 sw=2 sts=2
au FileType html        setl ts=4 sw=4 sts=4
au FileType sql         setl ts=2 sw=2 sts=2
au FileType python      setl ts=4 sw=4 sts=4 completeopt-=preview
au FileType make        setl noet
au FileType json        setl ts=2 sw=2 sts=2
