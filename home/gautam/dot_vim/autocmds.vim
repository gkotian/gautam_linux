" -------------
" Auto commands
" -------------

if has("autocmd")
    augroup MyAutoCommands
        " Clear the auto command group so we don't define it multiple times
        autocmd!

        " Source the vimrc file as soon as it is saved.
        autocmd BufWritePost .vimrc source $MYVIMRC

        " Set scripts to be executable if the first line starts with '#!/bin/'
        autocmd BufWritePost * if getline(1) =~ "^#!/bin/" | silent execute "!chmod a+x <afile>" | endif

        " No formatting on 'o' key newlines
        autocmd BufNewFile,BufEnter * set formatoptions-=o

        " Remove trailing whitespace whenever a buffer is saved
        " (only for files with specified file extensions)
        autocmd BufWritePre *.d,*.sh,*.txt :%s/\s\+$//e

        " Help mode bindings
        " <enter> to follow tag, <bs> to go back, and q to quit.
        autocmd FileType help nnoremap <buffer><cr> <c-]>
        autocmd FileType help nnoremap <buffer><bs> <c-T>
        autocmd FileType help nnoremap <buffer>q :q<CR>

        " Turn off syntax highlighting for Benu's cmd files.
        " now obsolete
        "autocmd BufEnter *.cmd syntax off
        "autocmd BufLeave *.cmd syntax on
    augroup END
endif

