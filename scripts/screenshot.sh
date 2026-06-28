#!/bin/sh

# To launch this script using dmenu, simply create symlinks as:
#     ln -sf ~/bin/screenshot.sh ~/bin/screenshot-full
#     ln -sf ~/bin/screenshot.sh ~/bin/screenshot-selection

output='/tmp/screenshot-%Y-%m-%d-%H%M%S.png'

case "$(basename "$0")" in
  screenshot-full)
    exec scrot --silent "$output"
    ;;

  screenshot-selection)
    exec scrot --silent --select "$output"
    ;;

  screenshot.sh)
    case "$1" in
      full)
        exec scrot --silent "$output"
        ;;
      selection|select)
        exec scrot --silent --select "$output"
        ;;
    esac
    ;;
esac

printf 'Usage: screenshot.sh {full|selection}\n' >&2
exit 2
