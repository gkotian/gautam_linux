" Function to show a vertical bar
" the bar is displayed at the text width if the text width has been set, and
" at 100 characters if not.
function! ShowBar()
    if TextWidthSet()
        set colorcolumn=-0
    else
        set colorcolumn=100
    endif
endfunction

" Function to check whether the text width has been set for the current buffer
function! TextWidthSet()
    if &l:textwidth ># 0
        return 1
    endif
endfunction

