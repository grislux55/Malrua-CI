#!/bin/bash

./build_clean.sh

mkdir -p out
export ARCH=arm64
export SUBARCH=arm64
export CLANG_PATH=$HOME/kernel/clang/proton-clang/bin
export PATH="$CLANG_PATH:$PATH"
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-

echo
echo "Setting DEFCONFIG....."
echo 
make CC=clang AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip O=out vendor/malrua_defconfig

echo
echo "Building kernel......"
echo 

make CC=clang AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip O=out -j$(nproc --all)

echo
echo "Outputing kernel......"
echo 
find out/arch/arm64/boot/dts -name '*.dtb' -exec cat {} + > dtb
cp -fp out/arch/arm64/boot/Image.gz Image.gz
