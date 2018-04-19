" For files that don't have any extension, set the filetype to conf
" This setting can be overridden in specific files using a vim modeline
au BufNewFile,BufRead * if &ft == '' | setf conf | endif

