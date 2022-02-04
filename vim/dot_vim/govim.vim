" -remote=auto is to make sure that a single, shared gopls daemon process is
"  responsible for managing all gopls sessions. This better supports my normal
"  workflow of having multiple vim sessions at the same time, and also having
"  short-lived vim sessions.
"  more info at: https://github.com/golang/tools/blob/master/gopls/doc/daemon.md
" -remote.listen.timeout=0 is to make sure that the single remote instance of
"  gopls is not killed when the last govim client instance is closed. This is in
"  order to keep the gopls caches warm.
let $GOVIM_GOPLS_FLAGS="-remote=auto; -remote.listen.timeout=0"

" Turn off log files generation. (Currently, govim generates logs by default.)
let $GOVIM_LOG="off"

" Don't highlight all occurrences of the word under the cursor. I find this very
" distracting.
call govim#config#Set("HighlightReferences", 0)
