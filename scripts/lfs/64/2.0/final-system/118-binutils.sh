#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=binutils-2.24.tar.bz2

if ! grep 119-binutils $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


expect -c "spawn ls"

mkdir -v ../binutils-build
cd ../binutils-build

CC="gcc -isystem /usr/include" \
LDFLAGS="-Wl,-rpath-link,/usr/lib:/lib" \
  ../binutils-2.24/configure --prefix=/usr \
    --libdir=/usr/lib --enable-shared \
    --disable-multilib --enable-64-bit-bfd

make tooldir=/usr

ln -sv /lib /lib64

rm -v /lib64

rm -v /usr/lib64/libstd*so*
rmdir -v /usr/lib64

make tooldir=/usr install

cd $SOURCE_DIR
rm -rf $DIR
rm -rf binutils-build

echo 119-binutils >> $LOG

fi
