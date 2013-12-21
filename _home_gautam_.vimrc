" Insert 4 spaces instead of tabs
set expandtab
set tabstop=4

" Enable auto-indentation
set autoindent

" Enable line numbers
set number

" Enable incremental search
set incsearch

" Enable search highlighting
set hlsearch

" Case insensitive searching
set ignorecase
set smartcase " case-sensitive if search contains an uppercase character
              " (valid only when 'ignorecase' is on)

" Set the shift width for indentations ('>>' & '<<')
set shiftwidth=4

" Set scroll offset to 'n' so that there are always 'n' lines above and below the cursor (the
" cursor will reach the top or bottom only at the beginning or end of the file respectively).
" Setting scroll offset to 999 will make the cursor always remain in the middle.
set scrolloff=3

" Set the number of characters per line
set columns=100

" Look in the current directory for the tags file, and work up the tree towards root until one is
" found
set tags=./tags;

" Enable the taglist plugin
filetype plugin on

set ofu=syntaxcomplete#Complete

" Press Space to turn off highlighting and clear any message already displayed.
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" Map F1 to save the current file
map <F1>  :w<CR>

" Map F2 to change to the previously opened file
map <F2>  :e#<CR>

" Map F3 to jump to tag
map <F3> <C-]>

" Map F4 to show/hide tags
nnoremap <silent> <F4> :TlistToggle<CR>

" Map function keys F9 to F12 to play whatever has been recorded into 'q', 'w', 'e' & 'r'
" respectively
map <F9>  @q
map <F10> @w
map <F11> @e
map <F12> @r

" Map HOME key to jump to the first character in the line.
map <HOME> ^
imap <HOME> <ESC>^i

" DOESN'T WORK!!!!!!!!
" Map <Ctrl+S> to save the current file
"map <C-s> :w<CR>

" Map '\l' to toggle display of invisible characters (tabs & newlines).
" Tabs are shown as '^I' & newlines are shown as '$'. To change this, or to
" display other invisible characters - :help listchars
" To change the display colour, tabs are represented by 'SpecialKey' and
" newlines by 'NonText' in the colorscheme file.
" (http://vimcasts.org/episodes/show-invisibles)
nmap <leader>l :set list!<CR>

" Map '\c' & '\h' to switch to corresponding .c or .h files respectively, with
" respect to the current buffer.
nmap <leader>c :e %:r.c
nmap <leader>h :e %:r.h

" Map '\i' to automatically insert my usual function body template.
nmap <leader>i o{<CR>    STATUS rc = ERROR;<CR><CR>do<CR>{<CR>    rc = OK;<CR><BS><BS><BS><BS>}<CR>while (0);<CR><CR>return rc;<CR><BS><BS><BS><BS>}<CR><ESC>

" Map '\v' to open the vimrc
nmap <leader>v :e $MYVIMRC<CR>

" Map '\r' to open reminders
nmap <leader>r :e /home/gautam/.reminders<CR>

" Use my colorscheme
colorscheme googie_colors

" Augment existing editor commands.
" The "!" (bang attribute) after the keyword 'command' tells vim to redefine
" the command everytime vimrc is sourced. Otherwise the new command would get
" appended to list of existing commands.
command! RemoveMultipleBlankLines %s/^\_s\+\n/\r
command! RemoveTrailingWhiteSpace %s/\s\+$//

" Autocommands
if has("autocmd")
    " Turn off syntax highlighting for Benu's cmd files.
    autocmd BufEnter *.cmd syntax off
    autocmd BufLeave *.cmd syntax on

    " Source the vimrc file as soon as it is saved.
    autocmd bufwritepost .vimrc source $MYVIMRC
endif " has("autocmd")


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Taglist plugin related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Move the cursor to the taglist window when it is opened using ":TlistToggle"
let Tlist_GainFocus_On_ToggleOpen=1

" Automatically close the taglist window when a tag or file is selected
let Tlist_Close_On_Select=1

" Exit vim if only the taglist window is remaining
let Tlist_Exit_OnlyWindow=1

" Show the taglist window on the right side of the Vim window
let Tlist_Use_Right_Window=1

" Don't display the fold column in the taglist window
let Tlist_Enable_Fold_Column=0

" Display the current tag name in the title bar
set title titlestring=%<%f\ %([%{Tlist_Get_Tagname_By_Line()}]%)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Navigation related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Move between split windows with Alt+Arrow instead of Ctrl+w+Arrow
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Statusbar related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 'laststatus' controls when the status bar is displayed
"     0 => never displayed
"     1 => displayed only when there is more than one window
"     2 => always displayed
set laststatus=2

" Control what is displayed on the status bar
"     %t => only the file name
"     %m => file modified flag
"     %r => read only flag
"     %= => left/right separator
"     %l => cursor line number
"     %L => total number of lines
"     %c => cursor column
"
"     %{strlen(&fenc)?&fenc:'none'} => file encoding
"     %{&ff}                        => file format
"
" For more, :help statusline

set statusline=%t%m%r\ [buf\ %n]%=[line\ %l\ of\ %L,\ col\ %c]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Define necessary highlight groups
highlight ExtraWhitespace ctermbg=red guibg=red
highlight LineTooLong     ctermbg=red ctermfg=white

" Map '\st' to show tabs and trailing whitespace
nnoremap <Leader>st :match ExtraWhitespace /\s\+$\<Bar>\t/<CR>

" Map '\sl' to show too long lines
nnoremap <Leader>sl :match LineTooLong     /\%100v.\+/<CR>

" Map '\h' to hide all matches
nnoremap <Leader>h  :match<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map '\sb' to show a bar at line length & '\hb' to remove it
nnoremap <Leader>sb :set colorcolumn=100<CR>
nnoremap <Leader>hb :set colorcolumn=<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Swapping split windows (using sgriffin's answer at:
" http://stackoverflow.com/questions/2586984/how-can-i-swap-positions-of-two-open-files-in-splits-in-vim)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! MarkWindowSwap()
    let g:markedWinNum = winnr()
endfunction

function! DoWindowSwap()
    "Mark destination
    let curNum = winnr()
    let curBuf = bufnr( "%" )
    exe g:markedWinNum . "wincmd w"
    "Switch to source and shuffle dest->source
    let markedBuf = bufnr( "%" )
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' curBuf
    "Switch to dest and shuffle source->dest
    exe curNum . "wincmd w"
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' markedBuf
endfunction

nnoremap <silent> <leader>mw :call MarkWindowSwap()<CR>
nnoremap <silent> <leader>sw :call DoWindowSwap()<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Search visually selected text using '*' or '#'
" (http://vim.wikia.com/wiki/Search_for_visually_selected_text)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vnoremap <silent> * :<C-U>
    \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
    \gvy/<C-R><C-R>=substitute(escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
    \gV:call setreg('"', old_reg, old_regtype)<CR>

vnoremap <silent> # :<C-U>
    \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
    \gvy?<C-R><C-R>=substitute(escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
    \gV:call setreg('"', old_reg, old_regtype)<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" https://github.com/tpope/vim-pathogen
execute pathogen#infect()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Startify plugin related
" (https://github.com/mhinz/vim-startify)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:startify_custom_header = [
\ '      ________               __                    ____  __       __   __               ',
\ '     /  _____/_____   __ ___/  |______    _____   |    |/ _|_____/  |_|__|____    ____  ',
\ '    /   \  ___\__  \ |  |  \   __\__  \  /     \  |      < /  _ \   __\  \__  \  /    \ ',
\ '    \    \_\  \/ __ \|  |  /|  |  / __ \|  Y Y  \ |    |  (  <_> )  | |  |/ __ \|   |  \',
\ '     \______  (____  /____/ |__| (____  /__|_|  / |____|__ \____/|__| |__(____  /___|  /',
\ '            \/     \/                 \/      \/          \/                  \/     \/ ',
\ '',
\]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Temporary

