" Stop highlighting trailing whitespace for Go files, as it's very distracting.
" (https://stackoverflow.com/a/40945424/793930)
let g:go_highlight_trailing_whitespace_error=0

" <leader>ie (insert error) : insert code to check error
nnoremap <leader>ie iif err != nil {<CR>}<ESC>O

" <leader>pv (print value) : insert code to print the value of the variable
" under the cursor
nnoremap <Leader>pv yiwofmt.Println("<ESC>pa = ", <ESC>pa)<ESC>
