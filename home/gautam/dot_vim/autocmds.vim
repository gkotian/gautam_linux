" -------------
" Auto commands
" -------------

if has("autocmd")
    augroup MyAutoCommands
        " Clear the auto command group so we don't define it multiple times
        autocmd!

        " Source the vimrc file as soon as it is saved.
        autocmd BufWritePost .vimrc source $MYVIMRC

        " No formatting on 'o' key newlines
        autocmd BufNewFile,BufEnter * set formatoptions-=o

        " Remove trailing whitespace whenever a buffer is saved
        autocmd BufWritePre *.d :%s/\s\+$//e

        " TODO: what are these?
        autocmd FileType d :setl cinoptions=(0,u0,U0
        autocmd FileType d set et

        " Set textwidth to 80 characters per line
        autocmd FileType d set tw=80

        " Help mode bindings
        " <enter> to follow tag, <bs> to go back, and q to quit.
        autocmd filetype help nnoremap <buffer><cr> <c-]>
        autocmd filetype help nnoremap <buffer><bs> <c-T>
        autocmd filetype help nnoremap <buffer>q :q<CR>

        " Turn off syntax highlighting for Benu's cmd files.
        " now obsolete
        "autocmd BufEnter *.cmd syntax off
        "autocmd BufLeave *.cmd syntax on
    augroup END
endif

