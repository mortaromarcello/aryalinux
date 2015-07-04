#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/mnt/clfs/sources
export LOG=/mnt/clfs/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=binutils-2.24.tar.bz2

if ! grep 035-binutils $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


mkdir -v ../binutils-build
cd ../binutils-build

AR=ar AS=as ../binutils-2.24/configure \
    --prefix=/cross-tools --host=${CLFS_HOST} --target=${CLFS_TARGET} \
    --with-sysroot=${CLFS} --with-lib-path=/tools/lib --disable-nls \
    --disable-static --enable-64-bit-bfd --disable-multilib --disable-werror

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 035-binutils >> $LOG

fi
