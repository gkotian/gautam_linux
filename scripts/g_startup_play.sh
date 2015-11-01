#!/bin/sh

# Add the necessary passphrases to ssh agent
ssh-add ~/.ssh/id_rsa_personal

# Launch gitk for commonly monitored projects
cd /home/gautam/play/gautam_linux   && gitk --all&
cd /home/gautam/play/git_scripts    && gitk --all&
cd /home/gautam/play/python_scripts && gitk --all&
cd /home/gautam/play/website        && gitk --all&

