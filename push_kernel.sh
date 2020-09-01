#!/bin/bash

echo "Pushing!"

commit="$(cat version)-$(cut -c-12 <<< "$(git rev-parse HEAD)")"

git config --global user.name $GITNAME
git config --global user.email $GITEMAIL

git clone https://$GITID:$GITPWD@github.com/$GITID/kernel_release
cd kernel_release
mkdir -p "malrua/q/$commit"
cp ../dtb "./malrua/q/$commit"
cp ../Image.gz "./malrua/q/$commit"

git add . && git commit -m "build for $commit" -s
git push https://$GITID:$GITPWD@github.com/$GITID/kernel_release HEAD:master

