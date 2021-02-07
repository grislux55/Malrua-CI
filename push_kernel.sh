#!/bin/bash

echo
echo "Pushing!"
echo

VERSION="$(cat version)"

curl -sL https://git.io/file-transfer | sh
./transfer wet $VERSION.zip
