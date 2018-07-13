The stock '/usr/bin/slock' binary installed when installing the suckless-tools
package in 18.04 doesn't lock the screen when launched using the 'mod+Control+l'
shortcut key defined in i3config (but locks the screen correctly when run from
the command-line).

This stock binary has the following version:
    $> /usr/bin/slock -v
    slock-1.4
And the shortcut is defined as:
    bindsym $mod+Control+l exec slock

The stock binary installed in 16.04 works both via the shortcut and the
command-line. So to save me some trouble, I'm just taking the stock binary from
16.04, and using that in 18.04

The stock binary from 16.04 has the following version:
    $> /usr/bin/slock -v
    slock-1.3, © 2006-2016 slock engineers

To get the stock 16.04 binary, just:
------------------------------------
    mkdir /tmp/slock
    cd /tmp/slock
    dockershell
    then inside the container:
        cp /usr/bin/slock .
    exit the container
    sudo mv /usr/bin/slock /usr/bin/slock.orig
    sudo chown root:root /tmp/slock/slock
    sudo mv /tmp/slock/slock /usr/bin/slock

If you want to try and build slock inside the container:
--------------------------------------------------------
    <make sure that /tmp/slock doesn't exist>
    git clone https://git.suckless.org/slock /tmp/slock
    cd /tmp/slock
    mv Dockerfile Dockerfile.orig
    mv Dockerfile-build Dockerfile
    dockershell
    then inside the container:
        make
