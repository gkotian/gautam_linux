## Current system's machine ID

cat /var/lib/dbus/machine-id

## Steps to restore packages

1. cat pacman-packages.txt | xargs doas pacman -S --needed --noconfirm
1. doas pacman -Syu
1. git clone https://aur.archlinux.org/yay.git /tmp/yay
1. cd /tmp/yay
1. makepkg --syncdeps --install --clean
1. doas pacman -U <tar.zst>
1. Open foreign-packages.txt and remove from it:
     - `yay` (as we already installed it above)
     - all packages that you don't recognize/need
1. cat foreign-packages.txt | xargs yay -S
