" --------------
"     Vundle
" --------------

set nocompatible " be iMproved, required
filetype off     " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle, required
Plugin 'gmarik/vundle'

Plugin 'airblade/vim-gitgutter'
Plugin 'ConradIrwin/vim-bracketed-paste'
Plugin 'ervandew/supertab'
Plugin 'govim/govim'
Plugin 'junegunn/fzf.vim'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'mhinz/vim-startify'
Plugin 'rking/ag.vim'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'

" ----------------------
"     Plugins to try
" ----------------------
"Plugin 'vim-scripts/Smart-Tabs' Do I need this?
