" Automatically install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Automatically install the neovim version
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim')) && has('nvim')
    silent !sh -c 'curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs 
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-fugitive'

Plug 'ctrlpvim/ctrlp.vim'
map <C-p> :CtrlP<CR>
map <C-t> :CtrlPTag<CR>

Plug 'preservim/nerdtree'
let g:NERDTreeWinPos = "right"
map <C-n> :NERDTreeToggle<CR>

Plug 'preservim/nerdcommenter'
let g:NERDSpaceDelims = 1
let g:NERDToggleCheckAllLines = 1
map <C-C> <Plug>NERDCommenterToggle

Plug 'dense-analysis/ale'
let g:ale_fixers = {
            \   '*': ['remove_trailing_lines', 'trim_whitespace'],
            \   'python': ['black'],
            \   'rust': ['rustfmt'],
            \   'go': ['gofmt'],
            \}
let g:ale_linters = {
            \   'go': ['golint', 'gopls'],
            \}
nmap K <Plug>(ale_hover)

" Themes
Plug 'tomasr/molokai'
Plug 'sjl/badwolf'
Plug 'NLKNguyen/papercolor-theme'
Plug 'morhetz/gruvbox'
let g:gruvbox_contrast_dark='hard'

call plug#end()

if has('autocmd')
    filetype plugin indent on
    filetype plugin on
endif

if has('syntax') && !exists('g:syntax_on')
    syntax enable
endif

" Use :help 'option' to see the documentation for the given option.
set hidden
set nobackup
set nowritebackup
set updatetime=300
set nocompatible
set background=dark
set number
set noswapfile
set autoindent
set backspace=indent,eol,start
set complete-=i
set smarttab
set nrformats-=octal
set tabstop=4 shiftwidth=4 expandtab
set termguicolors
set t_Co=256
set clipboard+=unnamed
set splitright
set mouse=a
colorscheme papercolor

set guifont=Fira\ Code\ Retina:h14
set guioptions-=r
set guioptions-=L
if !has('nvim') && &ttimeoutlen == -1
    set ttimeout
    set ttimeoutlen=100
endif

if has("patch-8.1.1564")
    set signcolumn=number
else
    set signcolumn=auto
endif

set incsearch
set laststatus=2
set ruler
set display+=lastline
set autoread

