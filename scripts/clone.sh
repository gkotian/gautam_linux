REPO=epexml && \
git clone git@github-WORK:frequenz-io/${REPO}.git ~/work/${REPO} && \
cd ~/work/${REPO} && \
git remote rename origin upstream && \
git remote add fork git@github-WORK:gautam-kotian-frequenz/${REPO}.git && \
git config user.email "blah@users.noreply.github.com" &&
git config user.signingkey "XXX" && \
v ~/work/${REPO}/.git/config && \
cd -
