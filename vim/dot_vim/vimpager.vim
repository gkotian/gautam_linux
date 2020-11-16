" By default, if the file is shorter than the height of the terminal, then
" instead of paging, vimpager just displays the file using vimcat. For me, this
" partially destroys the purpose of using vimpager, as besides having vim-like
" colours & keybindings, I also want my console window to not be cluttered with
" the file contents. Therefore, disable passthrough so that vimpager is used
" also for short files.
let vimpager_passthrough = 0
