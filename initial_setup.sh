#!/bin/bash

THE_USER=${SUDO_USER:-${USERNAME:-unknown}}
PLAY_DIR="/home/$THE_USER/play"
WORK_DIR="/home/$THE_USER/work"
GL_DIR="$PLAY_DIR/gautam_linux"
# GITHUB_HOST="github-PERSONAL"
GITHUB_HOST="github.com"

PACKAGES_LIST=(exuberant-ctags git gitk google-chrome-stable gthumb i3 kdiff3
               meld pdftk pyrenamer silversearcher-ag suckless-tools vim vlc
               xchat)

function waitForConfirmation
{
    echo "Press 'Enter' when done."
    read -s -n 1 C
    while [ -n "$C" ];
    do
        read -s -n 1 C
    done
    echo ""
}

echo -n "Checking internet connectivity... "
wget -q --tries=10 --timeout=20 --spider http://google.com
if [[ $? -ne 0 ]]; then
    echo "Not connected to the Internet. Aborting."
    exit 1
fi
echo "Connected!"

echo -n "Checking super-user privileges... "
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Aborting."
   exit 2
fi
echo "Done!"

echo -n "Checking who's the standard user... "
if [ "${THE_USER}" == "unknown" ]; then
    echo "unknown. Aborting."
    exit 3
fi
echo "$THE_USER"

echo -n "Adding the git-core PPA... "
apt-add-repository -y ppa:git-core/ppa > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "Failed. Aborting."
    exit 4
fi
echo "Done!"

echo -n "Adding Google Chrome PPA... "
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - > /dev/null
sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
echo "Done!"

echo -n "Updating package lists... "
apt-get update > /dev/null
if [[ $? -ne 0 ]]; then
    echo "Aborting."
    exit 5
fi
echo "Done!"

echo "Installing packages:"
for PACKAGE in ${PACKAGES_LIST[@]}
do
    echo -n "    $PACKAGE... "
    apt-get install -qq $PACKAGE > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo "Failed."
    else
        echo "Done!"
    fi
done

echo -n "Setting up ssh to access GitHub... "
sudo -u ${THE_USER} ssh-keygen -f /home/$THE_USER/.ssh/id_rsa_personal

echo "Now log in to GitHub -> Settings -> SSH keys -> Add SSH key"
echo "In 'Title' enter some text to identify this computer"
echo "In 'Key' paste the following:"
cat /home/$THE_USER/.ssh/id_rsa_personal.pub
echo ""
waitForConfirmation

echo "In a new terminal/tab run the following command:"
echo "    ssh -T git@$GITHUB_HOST"
echo "You should get the following output:"
echo "    Hi gkotian! You've successfully authenticated, but GitHub does not provide shell access."
waitForConfirmation

echo -n "Creating directory: '$PLAY_DIR'... "
sudo -u ${THE_USER} mkdir $PLAY_DIR
echo "Done!"

echo "In the other terminal/tab run the following command:"
echo "    git clone git@$GITHUB_HOST:gkotian/gautam_linux.git $PLAY_DIR/gautam_linux"
waitForConfirmation

echo "Creating symbolic links for:"
echo -n "    SSH config file... "
rm -f /home/$THE_USER/.ssh/config
sudo -u ${THE_USER} ln -s $GL_DIR/misc/ssh_config /home/$THE_USER/.ssh/config
echo "Done!"

echo -n "    .bashrc... "
rm -f /home/$THE_USER/.bashrc
sudo -u ${THE_USER} ln -s $GL_DIR/home/gautam/dot_bashrc /home/$THE_USER/.bashrc
echo "Done!"

echo -n "    .vim... "
rm -rf /home/$THE_USER/.vim
sudo -u ${THE_USER} ln -s $GL_DIR/home/gautam/dot_vim /home/$THE_USER/.vim
echo "Done!"

echo -n "    .vimrc... "
rm -f /home/$THE_USER/.vimrc
sudo -u ${THE_USER} ln -s $GL_DIR/home/gautam/dot_vim/vimrc /home/$THE_USER/.vimrc
echo "Done!"

echo -n "    .gitconfig... "
rm -f /home/$THE_USER/.gitconfig
sudo -u ${THE_USER} ln -s $GL_DIR/home/gautam/dot_gitconfig /home/$THE_USER/.gitconfig
echo "Done!"

echo -n "    .gitignore_global... "
rm -f /home/$THE_USER/.gitignore_global
sudo -u ${THE_USER} ln -s $GL_DIR/home/gautam/dot_gitignore_global /home/$THE_USER/.gitignore_global
echo "Done!"

# For using Google's public DNS servers
echo -n "    /etc/resolvconf/resolv.conf.d/head... "
rm -f /etc/resolvconf/resolv.conf.d/head
ln -s $GL_DIR/misc/resolv_conf_head /etc/resolvconf/resolv.conf.d/head
echo "Done!"

# echo -n "    .xmonad... "
# rm -f /home/$THE_USER/.xmonad
# sudo -u ${THE_USER} ln -s $GL_DIR/home/gautam/dot_xmonad /home/$THE_USER/.xmonad
# echo "Done!"

# echo -n "    .xmobarrc... "
# rm -f /home/$THE_USER/.xmobarrc
# sudo -u ${THE_USER} ln -s $GL_DIR/home/gautam/dot_xmobarrc /home/$THE_USER/.xmobarrc
# echo "Done!"

echo -n "    .i3/config... "
if [ ! -d "/home/$THE_USER/.i3" ]; then
    sudo -u ${THE_USER} mkdir /home/$THE_USER/.i3
fi
rm -f /home/$THE_USER/.i3/config
sudo -u ${THE_USER} ln -s $GL_DIR/i3/config /home/$THE_USER/.i3/config
echo "Done!"

# For using the compose key and defining custom key-mappings
# (haven't yet figured out how to make it work with xmonad)
echo -n "    .XCompose... "
rm -f /home/$THE_USER/.XCompose
sudo -u ${THE_USER} ln -s $GL_DIR/home/gautam/dot_XCompose /home/$THE_USER/.XCompose
echo "Done!"

echo -n "    .gnomerc... "
rm -f /home/$THE_USER/.gnomerc
sudo -u ${THE_USER} ln -s $GL_DIR/home/gautam/dot_gnomerc /home/$THE_USER/.gnomerc
echo "Done!"

echo -n "    /usr/bin/chrome... "
rm -f /usr/bin/chrome
ln -s /usr/bin/google-chrome /usr/bin/chrome
echo "Done!"

# Other lists can be created as needed by linking to the same dmenu_list script
echo -n "    /usr/local/bin/todo... "
rm -f /usr/local/bin/todo
ln -s $GL_DIR/scripts/dmenu_list.sh /usr/local/bin/todo
echo "Done!"

echo -n "    /usr/bin/dmenu_path... "
rm -f /usr/bin/dmenu_path
sudo ln -s $GL_DIR/scripts/dmenu_path.sh /usr/bin/dmenu_path
echo "Done!"

echo ""
echo -n "Setting up 'c' to launch calendar... "
TMP_FILE=mktemp
echo '#!/bin/bash' > $TMP_FILE
echo "zenity --calendar" >> $TMP_FILE
chmod +x $TMP_FILE
mv $TMP_FILE /usr/local/bin/c
echo "Done!"

if [ -d "/home/$THE_USER/.vim" ]; then
    echo "In the other terminal/tab run the following command:"
    echo "    git clone git@$GITHUB_HOST:gmarik/Vundle.vim.git /home/$THE_USER/.vim/bundle/vundle"
    waitForConfirmation

    echo -n "Installing all Vim plugins... "
    sudo -u ${THE_USER} vim +PluginInstall +qall
    echo "Done!"
fi

# Set up work specific links
# ln -s /path/to/g_sociomantic $GL_DIR/g_sociomantic
# ln -s /path/to/g_startup_sociomantic $GL_DIR/g_startup_sociomantic

# A work specific notes.txt is also present in the same directory as
# g_sociomantic. Make a link to this file also in a suitable location


echo "gnome-terminal setup"
echo "--------------------"
echo "    Open a gnome-terminal"
echo "    Edit -> profile preferences"
echo "        Tab General"
echo "            uncheck 'Use the system fixed width font'"
echo "            uncheck 'Show menubar by default in new terminals'"
echo "            Select-by-word characters -> remove ':' '='"
echo "        Tab Colors"
echo "            uncheck 'use colors from system theme', choose custom, text black, background gray"
echo "        Tab Scrolling"
echo "            check 'Scrollback unlimited'"
echo "    Edit -> keyboard shortcuts"
echo "        uncheck 'Enable menu access keys'"
echo "        uncheck 'Enable the menu shortcut key'"
echo "        under 'Shortcut keys -> View', disable full screen"
echo "        under 'Shortcut keys -> Help', disable contents"
waitForConfirmation

echo "google-chrome setup"
echo "-------------------"
echo "    Launch google-chrome, lock it to launcher and set it as the default browser"
waitForConfirmation

echo "default applications setup"
echo "--------------------------"
echo "    System Settings -> Details -> Default Applications"
echo "        Web    : Google Chrome"
echo "        Mail   : Thunderbird Mail"
echo "        Music  : VLC media player"
echo "        Video  : VLC media player"
echo "        Photos : gThumb"
waitForConfirmation

# The Anki website itself recommends downloading and installing
echo "anki setup"
echo "----------"
echo "    Go to http://ankisrs.net and download the .deb"
echo "    Open with ubuntu-software-center and install"
waitForConfirmation

echo "dropbox setup"
echo "-------------"
echo "    Install using the ubuntu-software-center"
waitForConfirmation

echo "skype setup"
echo "-----------"
echo "    Go to http://goo.gl/Kgrs5P and download the .deb"
echo "    Open with ubuntu-software-center and install"
waitForConfirmation

echo "You're all set. Congratulations!!"

exit 0

