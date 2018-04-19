" Vim color file
" Maintainer: Gautam "Googie" Kotian <gthm159@gmail.com>
" Original creator: Bram Moolenaar <Bram@vim.org>
" Last Change: 2007 Mar 22

" This color scheme contains colors used by Googie, built upon the default color scheme.
" It doesn't define the normal highlighting, it uses whatever colors used to be.

" For color codes, refer:
"     http://vim.wikia.com/wiki/Xterm256_color_names_for_console_Vim

" Set 'background' back to the default. The value can't always be estimated and is then guessed.
hi clear Normal
set bg&

" Remove all existing highlighting and set the defaults.
hi clear

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

let colors_name = "googie_colors"

" Uncomment any one section below depending on the terminal type (and comment the other two)
" (determining what your terminal type is may involve some trial-and-error)

" I have commented out lines where I like the default coloring scheme as it is. If you want to
" change the color of something, you may have to first look for the correct identifier and
" uncomment that line.

"==================================================================================================
"     Section 1: cterm colors
"==================================================================================================
  " for syntax highlighting
  " -----------------------
    "hi Comment              ctermfg=DarkBlue
    "hi Constant             ctermfg=DarkRed
    "hi Special              ctermfg=DarkMagenta
    "hi Identifier           ctermfg=DarkCyan                        cterm=NONE
     hi Statement            ctermfg=DarkRed                         cterm=bold
    "hi PreProc              ctermfg=DarkGreen
     hi Type                 ctermfg=DarkGreen
    "hi Ignore               ctermfg=Gray                            cterm=bold
     hi Error                ctermfg=Gray        ctermbg=DarkRed     cterm=bold
     hi Todo                 ctermfg=Black       ctermbg=Yellow      cterm=bold

  " for other stuff
  " ---------------
    "hi Normal               ctermfg=Black
    "hi SpecialKey           ctermfg=DarkBlue
    "hi NonText              ctermfg=DarkBlue                        cterm=bold
    "hi Directory            ctermfg=DarkBlue
    "hi ErrorMsg             ctermfg=Gray        ctermbg=DarkRed     cterm=bold
    "hi IncSearch                                                    cterm=reverse
    "hi Search               ctermfg=White       ctermbg=Black
    "hi MoreMsg              ctermfg=DarkGreen
    "hi ModeMsg                                                      cterm=bold
     hi LineNr               ctermfg=DarkBlue
    "hi Question             ctermfg=DarkGreen
    "hi StatusLine ,reverse                                          cterm=bold,reverse
    "hi StatusLineNC                                                 cterm=reverse
    "hi VertSplit                                                    cterm=reverse
    "hi Title                ctermfg=DarkMagenta
    "hi Visual                                                       cterm=reverse
    "hi VisualNOS ,underline                                         cterm=bold,underline
    "hi WarningMsg           ctermfg=DarkRed
    "hi WildMenu             ctermfg=Black       ctermbg=DarkYellow
    "hi Folded               ctermfg=DarkBlue    ctermbg=Gray
    "hi FoldColumn           ctermfg=DarkBlue    ctermbg=Gray
    "hi DiffAdd                                  ctermbg=DarkBlue
    "hi DiffChange                               ctermbg=DarkMagenta
    "hi DiffDelete           ctermfg=DarkBlue    ctermbg=6           cterm=bold
    "hi DiffText                                 ctermbg=DarkRed     cterm=bold
    "hi Cursor 
    "hi lCursor 
    "hi Match ,reverse       ctermfg=Blue        ctermbg=Yellow      cterm=bold,reverse

"==================================================================================================
"     Section 1: gui colors
"==================================================================================================
  " for syntax highlighting
  " -----------------------
    " TODO

  " for other stuff
  " ---------------
    " TODO

"==================================================================================================
"     Section 1: term colors
"==================================================================================================
  " for syntax highlighting
  " -----------------------
    " TODO

  " for other stuff
  " ---------------
    " TODO

  " vim: sw=2

