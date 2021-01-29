" C style indenting
setlocal cinoptions=(0,u0,U0

" Comments (for the commentary.vim plugin)
setlocal commentstring=//\ %s

" <leader>fh (function header) : insert code comments for a function header
nmap <leader>fh <DOWN>0f(y%O<ESC>i    /<ESC>75a*<ESC>o<CR>  TODO: Does what?<CR><CR>Params:<ESC>>>>>o    <ESC>p%o<CR><ESC>iReturns:<ESC>>>>>o    TODO<CR><CR><ESC>i    <ESC>75a*<ESC>a/<CR><ESC>

" <leader>iol (import ocean logger) : insert code to import the ocean logger
" (along with commonly accompanying statements)
nmap <leader>iol <ESC>gg/^module<CR>wyt;Goimport ocean.util.log.Logger;<CR>static private Logger log;<CR>static this ()<CR>{<CR>log = Log.lookup("<ESC>pa");<CR>}<ESC>Q

" <leader>is (import stdio) : insert code to import stdio
nnoremap <leader>is o<ESC>iimport std.stdio: writefln;<ESC>

" <leader>l (line) : split a line and a keep a four-space indent over the
" preceding line
nmap <leader>l i<CR><ESC><UP><HOME><DOWN>dw>>

" <leader>pv (print value) : insert code to print the value of the variable
" under the cursor
nnoremap <Leader>pv yiwo<ESC>iwritefln!"<C-o>p = %s"(<C-o>p);<ESC>
