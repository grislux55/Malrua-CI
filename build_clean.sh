#!/bin/bash

echo
echo "Cleaning build directory"
echo

git clean -fdx
git reset --hard
