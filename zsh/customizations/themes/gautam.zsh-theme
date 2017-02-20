local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)"
PROMPT='${ret_status}%{$fg_bold[green]%}%p %{$fg[blue]%}%~ %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="(%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# xx;yy
#   xx: 00 => normal, 01 => bold
#   yy: 30 => black,  34 => blue,       90 => dark gray,    94 => light blue,
#       31 => red,    35 => magenta,    91 => light red,    95 => light magenta,
#       32 => green,  36 => cyan,       92 => light green,  96 => light cyan,
#       33 => yellow, 37 => light gray, 93 => light yellow, 97 => white
export LS_COLORS='no=00;39:fi=00:di=00;34:ln=04;36:pi=40;33:so=01;35:bd=40;33;01:ex=00;91'
