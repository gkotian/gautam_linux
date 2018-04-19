"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-startify plugin related
" (https://github.com/mhinz/vim-startify)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:startify_custom_header = [
\ '      ________               __                    ____  __       __   __               ',
\ '     /  _____/_____   __ ___/  |______    _____   |    |/ _|_____/  |_|__|____    ____  ',
\ '    /   \  ___\__  \ |  |  \   __\__  \  /     \  |      < /  _ \   __\  \__  \  /    \ ',
\ '    \    \_\  \/ __ \|  |  /|  |  / __ \|  Y Y  \ |    |  (  <_> )  | |  |/ __ \|   Y  \',
\ '     \______  (____  /____/ |__| (____  /__|_|  / |____|__ \____/|__| |__(____  /___|  /',
\ '            \/     \/                 \/      \/          \/                  \/     \/ ',
\ '',
\]

let g:startify_files_number = 25

let g:startify_bookmarks = [ '~/.vimrc',
\                            '~/.bashrc',
\                            '~/play/gautam_linux/misc/g_aliases' ]

let g:startify_skiplist = [ 'COMMIT_EDITMSG',
\                           'HUB_EDITMSG',
\                           $VIMRUNTIME .'/doc' ]

" Shortcut to open the startify screen
nnoremap <silent> <Leader>s :Startify<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

