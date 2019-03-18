local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)"
PROMPT='${ret_status} %{$fg[red]%}%M %{$fg[blue]%}%~ % %{$reset_color%}'

# aa=xx;yy;zz
#   aa: file type
#           no => Global default,   fi => Normal file,            di => Directory,      ln => Symbolic link,
#           pi => Named pipe,       so => Socket,                 do => Door,           bd => Block device,
#           cd => Character device, or => Orphaned symbolic link, mi => Missing file,   su => Set UID,
#           sg => Set GID,          tw => Sticky other writable,  ow => Other writable, st => Sticky,
#           ex => Executable,       rs => Reset to normal color,  mh => Multi-Hardlink, ca => File with capability
#   xx: misc characteristics
#           00 => normal, 01 => bold, 02 => dim, 04 => underlined, 05 => blinking
#           07 => foreground and background colours inverted
#           08 => hidden (useful for passwords)
#   yy: foreground colour
#           30 => black,  34 => blue,       90 => dark gray,    94 => light blue,
#           31 => red,    35 => magenta,    91 => light red,    95 => light magenta,
#           32 => green,  36 => cyan,       92 => light green,  96 => light cyan,
#           33 => yellow, 37 => light gray, 93 => light yellow, 97 => white
#           39 => default foreground colour
#   zz: background colour
#           40 => black,  44 => blue,       100 => dark gray,    104 => light blue,
#           41 => red,    45 => magenta,    101 => light red,    105 => light magenta,
#           42 => green,  46 => cyan,       102 => light green,  106 => light cyan,
#           43 => yellow, 47 => light gray, 103 => light yellow, 107 => white
#           49 => default background colour
export LS_COLORS='no=00;39:fi=00:di=00;34:ln=04;36:or=04;93;41:pi=40;33:so=01;35:bd=40;33;01:ex=00;91'
