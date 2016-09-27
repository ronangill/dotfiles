" -------------------------------
" Local configuration
"
set nocompatible
set nopaste
set showmode
set autoindent
set smartindent
set pastetoggle=<f2>


set tabstop=4
set shiftwidth=4
set expandtab 
set showmatch
set ruler
set foldenable

set incsearch
set ignorecase
set hls

set mouse=a

syn on
if $USER == "root"
 set nomodeline
 set noswapfile
else
 set modeline
 set swapfile
endif

set fileencodings=utf-8
set encoding=utf-8


filetype plugin on
filetype indent on
set ofu=syntaxcomplete#Complete

autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType java set omnifunc=javacomplete#CompleteCSS

" filler to avoid the line above being recognized as a modeline
" filler
" filler

" Tabs stuff
map  <C-l> :tabn<CR>
map  <C-h> :tabp<CR>
map  <C-n> :tabnew<CR>

map <F2> :NERDTreeToggle<CR>


"inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
"inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
"inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
"inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
"inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
"inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
