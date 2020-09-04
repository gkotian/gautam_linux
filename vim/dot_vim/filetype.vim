if exists("did_load_filetypes")
    finish
endif

augroup filetypedetect
    " Recognise the filetype properly for commit messages within git submodules
    " (http://stackoverflow.com/questions/23635812/vim-syntax-coloring-for-git-commit-messages-in-submodules)
    au! BufNewFile,BufRead *.git/modules/**/COMMIT_EDITMSG setf gitcommit

    " Treat commit-* files as diff files (these files are created by gitk when
    " writing a commit to file)
    au BufNewFile,BufRead commit-* setf diff

    " Set git-hub's edit files to type gitcommit, but with textwidth of 100
    au! BufNewFile,BufRead HUB_EDITMSG setf gitcommit | setlocal tw=100

    " Treat *.md files as markdown instead of modula2
    au BufNewFile,BufRead *.md setf markdown
augroup END
