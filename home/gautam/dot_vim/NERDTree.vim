"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree plugin related
" (https://github.com/scrooloose/nerdtree)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Open a NERDTree automatically when vim starts up
" If no files are explicitly specified, open startify also
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | Startify | NERDTree | else | NERDTree | endif

" Set focus to the non-NERDTree split
" autocmd VimEnter * wincmd p

" Automatically close NERDtree after opening a file
let NERDTreeQuitOnOpen = 1

" Shortcut to open NERDTree
map <C-n> :NERDTreeToggle<CR>

" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

