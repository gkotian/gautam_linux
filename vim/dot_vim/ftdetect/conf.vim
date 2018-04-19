" For files that don't have any extension, set the filetype to conf
" This setting can be overridden in specific files by having a vim modeline at the top of the file,
" like so:
"     # vim: set ft=python
au BufNewFile,BufRead * if &ft == '' | setf conf | endif

