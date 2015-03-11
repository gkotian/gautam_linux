if exists("did_load_filetypes")
    finish
endif

augroup filetypedetect
    " Recognise the filetype properly for commit messages within git submodules
    " (http://stackoverflow.com/questions/23635812/vim-syntax-coloring-for-git-commit-messages-in-submodules)
    au! BufNewFile,BufRead *.git/modules/**/COMMIT_EDITMSG setf gitcommit

    " Treat *.md files as markdown instead of modula2
    au BufNewFile,BufRead *.md  setf markdown
augroup END

