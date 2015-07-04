#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/mnt/clfs/sources
export LOG=/mnt/clfs/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=binutils-2.24.tar.bz2

if ! grep 047-binutils $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


mkdir -v ../binutils-build
cd ../binutils-build

../binutils-2.24/configure \
    --prefix=/tools --build=${CLFS_HOST} --host=${CLFS_TARGET} \
    --target=${CLFS_TARGET} --with-lib-path=/tools/lib --disable-nls \
    --enable-shared --enable-64-bit-bfd --disable-multilib

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 047-binutils >> $LOG

fi
