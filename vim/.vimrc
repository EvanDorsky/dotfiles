
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
Plug 'altercation/vim-colors-solarized'

call plug#end()

""" Interface

syntax on
set background=dark
colorscheme solarized

set rnu
set cursorline

""" Editing

set title
set tabstop=4
set incsearch
set mouse=a
set backspace=indent,eol,start

""" Window config

set shortmess=atI
set showmode
set clipboard=unnamed
set wildmenu

""" Housekeeping

set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
	set undodir=~/.vim/undo
endif

