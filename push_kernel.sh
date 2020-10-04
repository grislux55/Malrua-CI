#!/bin/bash

echo "Pushing!"

VERSION="$(cat version)"
commit="$(cat version)-$(cut -c-12 <<< "$(git rev-parse HEAD)")"

git config --global user.name $GITNAME
git config --global user.email $GITEMAIL

git clone https://$GITID:$GITPWD@github.com/$GITID/kernel_release
cd kernel_release
mkdir -p "malrua/q/$commit"
cp ../$VERSION.zip "./malrua/q/$commit"

git add . && git commit -m "build for $commit" -s
git push https://$GITID:$GITPWD@github.com/$GITID/kernel_release HEAD:master

