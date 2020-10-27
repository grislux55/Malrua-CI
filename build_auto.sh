#!/bin/bash

KERNELDIR=`readlink -f .`

jobs="-j$(nproc --all)"

./build_clean.sh

git clone --depth=1 https://github.com/kdrag0n/proton-clang.git

export ARCH=arm64
export SUBARCH=arm64
export CLANG_PATH=$KERNELDIR/proton-clang/bin
export PATH="$CLANG_PATH:$PATH"
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-

echo "Compiling! (Using $jobs flag)"

./build_kernel.sh malrua_defconfig "$jobs"
