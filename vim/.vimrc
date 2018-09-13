
set nocompatible

""" Plugins

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'altercation/vim-colors-solarized'
Plug 'morhetz/gruvbox'

call plug#end()

""" Interface

syntax on
set background=dark
colorscheme gruvbox

""" Display

set rnu
set nu
set cursorline
set title
set incsearch " not sure what this does

""" Editing

set tabstop=4
set mouse=a
set backspace=indent,eol,start

""" Window config

" Suppress start message
set shortmess=atI
" Show filename
set showmode
" Use system clipboard
set clipboard=unnamed
" Better menu completion
set wildmenu

""" Housekeeping

set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
	set undodir=~/.vim/undo
endif

