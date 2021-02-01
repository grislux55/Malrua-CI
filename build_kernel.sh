#!/bin/bash

if [[ "${1}" == "var" ]] ; then
  export ARCH=arm64
  export SUBARCH=arm64
  export CLANG_PATH=$HOME/kernel/clang/proton-clang/bin
  export PATH="$CLANG_PATH:$PATH"
  export CROSS_COMPILE=aarch64-linux-gnu-
  export CROSS_COMPILE_ARM32=arm-linux-gnueabi-
  shift
fi

mkdir -p out

echo
echo "Setting DEFCONFIG....."
echo 
make CC=clang \
     AR=llvm-ar \
     AS=llvm-as \
     NM=llvm-nm \
     OBJCOPY=llvm-objcopy \
     OBJDUMP=llvm-objdump \
     STRIP=llvm-strip \
     O=out "${1}"

shift

echo
echo "Building kernel......"
echo 

make CC=clang \
     AR=llvm-ar \
     AS=llvm-as \
     NM=llvm-nm \
     OBJCOPY=llvm-objcopy \
     OBJDUMP=llvm-objdump \
     STRIP=llvm-strip \
     O=out "$@"

echo
echo "Outputing kernel......"
echo 
mkdir -p imgs
find out/arch/arm64/boot/dts -name '*.dtb' -exec cat {} + > ./imgs/dtb
cp -fp out/arch/arm64/boot/Image.gz ./imgs/Image.gz
