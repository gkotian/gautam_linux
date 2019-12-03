#!/bin/bash

THE_USER=${SUDO_USER:-${USERNAME:-unknown}}
PLAY_DIR="/home/$THE_USER/play"
GL_DIR="$PLAY_DIR/gautam_linux"

GITHUB_USERNAME="gkotian"

PACKAGES_LIST=(
    git
    gitk
    git-man
    i3
    kdiff3
    meld
    silversearcher-ag
    ssh-askpass
    suckless-tools
    vim
    vlc
    xclip
    zsh
)

PYTHON_PACKAGES_LIST=(pyenchant)

RUBY_PACKAGES_LIST=(jekyll)

MY_PROJECTS_LIST=(git_scripts gkotian.github.io python_scripts)

START_TIMESTAMP=$(date +%s)

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

function formatTime
{
    local T=$1
    local D=$((T / 60 / 60 / 24))
    local H=$((T / 60 / 60 % 24))
    local M=$((T / 60 % 60))
    local S=$((T % 60))

    (( $D > 0 )) && printf '%d days ' $D
    (( $H > 0 )) && printf '%d hours ' $H
    (( $M > 0 )) && printf '%d minutes ' $M
    (( $D > 0 || $H > 0 || $M > 0 )) && printf 'and '
    printf '%d seconds\n' $S
}

echo "Starting script at: `date +%H:%M:%S`"
echo ""

echo -n "Checking internet connectivity... "
wget -q --tries=10 --timeout=20 --spider http://google.com
if [[ $? -ne 0 ]]; then
    echo "Not connected to the Internet. Aborting." 1>&2
    exit 1
fi
echo "Connected!"

echo -n "Checking super-user privileges... "
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Aborting." 1>&2
   exit 2
fi
echo "Done!"

echo -n "Checking who's the standard user... "
if [ "${THE_USER}" == "unknown" ]; then
    echo "unknown. Aborting." 1>&2
    exit 3
fi
echo "$THE_USER"

echo -n "Enabling all the Ubuntu repositories... "
add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe restricted multiverse"
if [[ $? -ne 0 ]]; then
    echo "Failed. Aborting." 1>&2
    exit 5
fi
echo "Done!"

echo -n "Adding the git-core PPA... "
apt-add-repository -y ppa:git-core/ppa > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "Failed. Aborting." 1>&2
    exit 4
fi
echo "Done!"

echo ""
echo "In a new terminal/tab run the following command:"
echo "    sudo apt-get update"
waitForConfirmation

echo "Installing packages:"
for PACKAGE in ${PACKAGES_LIST[@]}
do
    echo -n "    $PACKAGE... "
    apt-get install -qq $PACKAGE > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo "Failed." 1>&2
    else
        echo "Done!"
    fi
done

echo "Installing python packages:"
for PACKAGE in ${PYTHON_PACKAGES_LIST[@]}
do
    echo -n "    $PACKAGE... "
    pip install $PACKAGE > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo "Failed." 1>&2
    else
        echo "Done!"
    fi
done

echo "Installing ruby packages:"
for PACKAGE in ${RUBY_PACKAGES_LIST[@]}
do
    echo -n "    $PACKAGE... "
    gem install $PACKAGE > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo "Failed."
    else
        echo "Done!"
    fi
done

echo "Changing default shell to zsh... "
# echo "    (enter ${THE_USER}'s password if asked for)"
# sudo -u ${THE_USER} chsh -s /bin/zsh
chsh -s /bin/zsh ${THE_USER}
echo "Done!"

echo -n "Setting up ssh to access GitHub... "
sudo -u ${THE_USER} ssh-keygen -t ed25519 -f /home/$THE_USER/.ssh/id_ed25519_play

echo "Now log in to GitHub -> Settings -> SSH and GPG keys -> New SSH key"
echo "In 'Title' enter some text to identify this computer"
echo "In 'Key' paste the following:"
cat /home/$THE_USER/.ssh/id_rsa_play.pub
echo ""
waitForConfirmation

echo "In the other terminal/tab run the following command:"
echo "    ssh -T git@github.com"
echo "(if a password is asked for, enter the passphrase used above while creating the public/private rsa key pair)"
echo "You should get the following output:"
echo "    Hi $GITHUB_USERNAME! You've successfully authenticated, but GitHub does not provide shell access."
waitForConfirmation

DIRECTORIES_TO_PRECREATE=(
    ${PLAY_DIR}
    /home/${THE_USER}/.gnupg
    /home/${THE_USER}/.i3
    /home/${THE_USER}/.ssh
    /home/${THE_USER}/bin
    /home/${THE_USER}/tmp_home
)

echo "Creating directories:"
for DIR in ${DIRECTORIES_TO_PRECREATE[@]}
do
    echo "    ${DIR}"
    sudo -u ${THE_USER} mkdir -p ${DIR}
done
echo "Done!"
echo ""

echo "In the other terminal/tab run the following command:"
echo "    git clone git@github.com:gkotian/gautam_linux.git $PLAY_DIR/gautam_linux"
waitForConfirmation

echo "In the other terminal/tab run the following command:"
echo "    git clone git@github.com:robbyrussell/oh-my-zsh.git $PLAY_DIR/oh-my-zsh"
waitForConfirmation

echo "Creating symbolic links for:"
echo -n "    SSH config file... "
sudo -u ${THE_USER} ln -srf $GL_DIR/misc/ssh_config /home/$THE_USER/.ssh/config
echo "Done!"

echo -n "    GPG agent config file... "
sudo -u ${THE_USER} ln -srf $GL_DIR/misc/gpg_agent_config /home/$THE_USER/.gnupg/gpg-agent.conf
echo "Done!"

echo -n "    zsh theme... "
sudo -u ${THE_USER} ln -srf $GL_DIR/zsh/customizations/themes/gautam.zsh-theme $PLAY_DIR/oh-my-zsh/themes/gautam.zsh-theme
echo "Done!"

echo -n "    .zshrc... "
sudo -u ${THE_USER} ln -srf $GL_DIR/zsh/zshrc /home/$THE_USER/.zshrc
echo "Done!"

echo -n "    .vim... "
sudo -u ${THE_USER} ln -srf $GL_DIR/vim/dot_vim /home/$THE_USER/.vim
echo "Done!"

echo -n "    .vimrc... "
sudo -u ${THE_USER} ln -srf $GL_DIR/vim/vimrc /home/$THE_USER/.vimrc
echo "Done!"

echo -n "    .gitconfig... "
sudo -u ${THE_USER} ln -srf $GL_DIR/git/gitconfig_global /home/$THE_USER/.gitconfig
echo "Done!"

echo -n "    .gitignore_global... "
sudo -u ${THE_USER} ln -srf $GL_DIR/git/gitignore_global /home/$THE_USER/.gitignore_global
echo "Done!"

# Open the NetworkManager gui, or nm-connection-editor, choose the connection of
# interest, go to the 'IPv4 Settings' and under "Additional DNS servers" add
# '1.1.1.1, 8.8.8.8'
# if there is a way to do this via nmcli we could automate this

echo -n "    .i3/config... "
sudo -u ${THE_USER} ln -srf $GL_DIR/i3/config /home/$THE_USER/.i3/config
echo "Done!"

echo -n "    calc (calculator)... "
sudo -u ${THE_USER} ln -srf $GL_DIR/scripts/calculator.sh /home/$THE_USER/bin/calc
echo "Done!"

echo -n "    c (calendar)... "
sudo -u ${THE_USER} ln -srf $GL_DIR/scripts/calendar.sh /home/$THE_USER/bin/c
echo "Done!"

echo -n "    clone... "
sudo -u ${THE_USER} ln -srf ${PLAY_DIR}/python_scripts/clone.py /home/$THE_USER/bin/clone
echo "Done!"

echo -n "    img (image viewer)... "
sudo -u ${THE_USER} ln -srf $GL_DIR/scripts/image_viewer.sh /home/$THE_USER/bin/img
echo "Done!"

echo -n "    screenshot... "
sudo -u ${THE_USER} ln -srf $GL_DIR/scripts/screenshot.sh /home/$THE_USER/bin/screenshot
echo "Done!"

echo -n "    umlauts... "
sudo -u ${THE_USER} ln -srf $GL_DIR/scripts/umlauts.sh /home/$THE_USER/bin/umlauts
echo "Done!"

echo -n "    .gdbinit... "
sudo -u ${THE_USER} ln -srf $GL_DIR/misc/gdbinit /home/$THE_USER/.gdbinit
echo "Done!"

echo -n "    /usr/bin/dmenu_path... "
rm -f /usr/bin/dmenu_path
sudo ln -s $GL_DIR/scripts/dmenu_path.sh /usr/bin/dmenu_path
echo "Done!"

echo -n "    PyPI config file... "
sudo -u ${THE_USER} ln -srf $GL_DIR/misc/pypi_config /home/$THE_USER/.pypirc
echo "Done!"

echo ""

# Now that the ssh config file has been linked, 'github-PLAY' can be used
# in the remote URLs of cloned repositories. Change the remote URLs accordingly
# for repositories that were created with 'github.com'.
cd $PLAY_DIR/gautam_linux
sudo -u ${THE_USER} git remote set-url origin git@github-PLAY:gkotian/gautam_linux.git

cd $PLAY_DIR/oh-my-zsh
sudo -u ${THE_USER} git remote set-url origin git@github-PLAY:robbyrussell/oh-my-zsh.git

cd

if [ -d "/home/$THE_USER/.vim" ]; then
    echo "In the other terminal/tab run the following command:"
    echo "    git clone git@github-PLAY:gmarik/Vundle.vim.git /home/$THE_USER/.vim/bundle/vundle"
    waitForConfirmation

    echo -n "Installing all Vim plugins... "
    sudo -u ${THE_USER} vim +PluginInstall +qall
    echo "Done!"
fi
echo ""

for PROJECT in ${MY_PROJECTS_LIST[@]}
do
    echo "In the other terminal/tab run the following command:"
    echo "    git clone git@github-PLAY:gkotian/$PROJECT.git $PLAY_DIR/$PROJECT"
    waitForConfirmation
done

echo "In the other terminal/tab, open the '/home/$THE_USER/.pypirc' file"
echo "and replace both occurrences of PASSWORD with the PyPI password."
waitForConfirmation

echo -n "Renaming '$PLAY_DIR/gkotian.github.io' to '$PLAY_DIR/website'... "
sudo -u ${THE_USER} mv $PLAY_DIR/gkotian.github.io $PLAY_DIR/website
echo "Done!"
echo ""

echo "Patching gitk... "
cp /usr/bin/gitk /usr/bin/gitk.orig
# Make selecting file names in the gitk diff view easier, by providing visual
# highlighting
echo -n "    removing 'filesep'... "
sed -i 's/^\(.*"\$pad \$fname \$pad"\) filesep$/\1/g' /usr/bin/gitk
echo "Done!"
# Use 5 instead of <Shift-F5> to reload commits
echo -n "    changing reload key to 5... "
sed -i 's/bindmodfunctionkey Shift 5 reloadcommits$/bindkey 5 reloadcommits/g' /usr/bin/gitk
echo "Done!"
echo "(you may want to check that gitk was patched correctly by running:"
echo "    meld /usr/bin/gitk.orig /usr/bin/gitk"
echo "in the other terminal/tab, and/or by launching gitk in any of the existing repos)"
echo ""

echo "docker setup"
echo "------------"
echo "Follow instructions in: https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-repository"
waitForConfirmation

echo "gopass setup"
echo "------------"
echo "In the other terminal/tab run the following commands:"
echo "    git clone git@gitlab-PLAY:gkotian/pass.git ${PLAY_DIR}/pass"
echo "    mkdir -p ${HOME}/.config/gopass"
echo "    ln -srf ${PLAY_DIR}/pass/config.yml ${HOME}/.config/gopass/config.yml"
echo "    ln -srf ${PLAY_DIR}/pass/store ${HOME}/.password-store"
echo "    docker build -t gopass github.com/gopasspw/gopass#master"
echo "    run 'gopass' to see if the credentials tree is shown"
echo "    import the GPG key from another trusted machine"
echo "    run 'gopass firefox' to see if the credentials can be correctly decrypted"
waitForConfirmation

echo "fzf setup"
echo "---------"
echo "In the other terminal/tab run the following commands:"
echo "    if ubuntu:"
echo "        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf"
echo "        ~/.fzf/install"
echo "            - Choose yes for enabling fuzzy auto-completion"
echo "            - Choose yes for enabling key bindings"
echo "            - Choose no for updating shell configuration files"
echo "        rm -f ${HOME}/.fzf.bash"
waitForConfirmation

echo "clone.py setup"
echo "--------------"
echo "Create the clone.py config file (format present at the top of ${PLAY_DIR}/python_scripts/clone.py)"
waitForConfirmation

echo "gnome-terminal setup"
echo "--------------------"
echo "    Open a gnome-terminal"
echo "    Edit -> profile preferences"
echo "        Tab General"
echo "            uncheck 'Use the system fixed width font'"
echo "            choose 'Monospace' as the font, and '13' as font size"
echo "            uncheck 'Terminal bell'"
echo "            Select-by-word characters -> remove ':' '='"
echo "                (it may not be there due to:"
echo "                 https://bugs.launchpad.net/ubuntu/+source/gnome-terminal/+bug/1401207)"
echo "        Tab Colors"
echo "            uncheck 'use colors from system theme', under 'Built-in schemes' choose custom"
echo "            text black (#000000), background gray (#B0B0B0)"
echo "        Tab Scrolling"
echo "            uncheck 'Limit scrollback to ...'"
echo "    Terminal -> preferences"
echo "        Tab General"
echo "            uncheck 'Show menubar by default in new terminals'"
echo "            uncheck 'Enable the menu accelerator key (F10 by default)'"
echo "        Tab Shortcuts"
echo "            under 'Shortcut keys -> View', disable full screen"
echo "            under 'Shortcut keys -> Help', disable contents"
waitForConfirmation

echo "google-chrome setup"
echo "-------------------"
echo "    Go to 'https://www.google.com/chrome/browser/desktop/index.html', download and install chrome"
waitForConfirmation
ln -s /usr/bin/google-chrome /usr/bin/chrome
echo "    Launch google-chrome, lock it to launcher and set it as the default browser"
echo "    Go to 'chrome://settings', scroll down to the end and click on 'Show advanced settings...'"
echo "    Scroll down further to 'Downloads'"
echo "    Edit the default path there to '/tmp' and check 'Ask where to save each file before downloading'"
echo "    also disable third-party tracking"
waitForConfirmation

echo "firefox setup"
echo "-------------"
echo "    log in to firefox so that things get synced"
echo "    don't save logins"
echo "    set download location to /tmp"
echo "    ask where to download every time"
echo "    disable third-party tracking"
waitForConfirmation

echo "signal messenger setup"
echo "----------------------"
echo "    mkdir ${HOME}/.signal-state"
echo "    docker-compose -f ${GL_DIR}/docker/signal/docker-compose.yml build"
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

echo "Disabling icons on Desktop (or else launching nautilus in i3 will open an
additional window)"
sudo -u ${THE_USER} gsettings set org.gnome.desktop.background show-desktop-icons false
echo "Done!"
echo ""

echo "Add gpg signing for commits"

echo "Set the variables 'MACHINE_TYPE' & 'IS_LAPTOP' in '${GL_DIR}/scripts/g_startup.sh' as appropriate"

echo "You're all set. Congratulations!!"

END_TIMESTAMP=$(date +%s)
TIME_TAKEN=$((END_TIMESTAMP - START_TIMESTAMP))
echo "Total time taken: `formatTime $TIME_TAKEN`"

exit 0
