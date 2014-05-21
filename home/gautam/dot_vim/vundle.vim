" --------------
"     Vundle
" --------------

set nocompatible " be iMproved, required
filetype off     " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle, required
Plugin 'gmarik/vundle'

" -------------------------
"     Installed plugins
" -------------------------
Plugin 'mhinz/vim-startify'
Plugin 'ervandew/supertab'
Plugin 'JesseKPhillips/d.vim'
Plugin 'rking/ag.vim'
Plugin 'tpope/vim-commentary'

" ----------------------
"     Plugins to try
" ----------------------
"Plugin 'tpope/vim-fugitive'

"Plugin 'vim-scripts/Smart-Tabs' Do I need this?

