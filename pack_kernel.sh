#!/bin/bash

echo
echo "Pack the zip"
echo 

VERSION="$(cat version)"

mkdir -p kernelzip
cp -rp ./ak3/* kernelzip/
cd kernelzip
cp -rfp ../imgs .
7za a -mx9 $VERSION-tmp.zip *
cd ..
cp -fp kernelzip/$VERSION-tmp.zip $VERSION.zip
rm -rf kernelzip
