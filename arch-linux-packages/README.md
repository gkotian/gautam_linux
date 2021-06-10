## Current system's machine ID

cat /var/lib/dbus/machine-id

## Steps to restore packages

1. cat pacman-packages.txt | xargs doas pacman -S --needed --noconfirm
1. doas pacman -Syu
1. mkdir /tmp/yay
1. cd /tmp/yay
1. curl --output yay.tar.gz https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz
1. tar zxf yay.tar.gz
1. cd yay
1. makepkg -Acs
1. doas pacman -U <tar.xz>
1. Open foreign-packages.txt and remove from it:
     - `yay` (as we already installed it above)
     - all packages that you don't recognize/need
1. cat foreign-packages.txt | xargs yay -S
