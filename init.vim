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

" Auto Complete
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"


" Plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'editorconfig/editorconfig-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'psliwka/vim-smoothie'
Plug 'jdkanani/vim-material-theme'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-fugitive'
Plug 'rhysd/committia.vim'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'

Plug 'leafgarland/typescript-vim'
Plug 'udalov/kotlin-vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'ryanolsonx/vim-lsp-javascript'
Plug 'ntpeters/vim-better-whitespace'
call plug#end()

" Color configuration
set bg=dark
color material-theme

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

" Language server
if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif

if executable('css-languageserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'css-languageserver',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'css-languageserver --stdio']},
        \ 'whitelist': ['scss', 'sass']
        \ })
endif

if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
        \ 'whitelist': ['typescript', 'typescriptreact'],
        \ })
endif

augroup LspGo
  au!
  autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'go-lang',
      \ 'cmd': {server_info->['gopls']},
      \ 'whitelist': ['go'],
      \ })
augroup END

let g:EditorConfig_core_mode = 'external_command'
let g:EditorConfig_exec_path = '/usr/local/bin/editorconfig'

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

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
au FileType go setlocal omnifunc=lsp#complete
au FileType go nmap <buffer> gd <plug>(lsp-definition)
au FileType go nmap <buffer> ,n <plug>(lsp-next-error)
au FileType go nmap <buffer> ,p <plug>(lsp-previous-error)
