#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=e2fsprogs-1.42.9.tar.xz

if ! grep 129-e2fsprogs $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


mkdir -v build
cd build

../configure --prefix=/usr --with-root-prefix="" \
    --enable-elf-shlibs --disable-libblkid \
    --disable-libuuid --disable-fsck \
    --disable-uuidd

make "-j`nproc`"

make install

make install-libs

cd $SOURCE_DIR
rm -rf $DIR
echo 129-e2fsprogs >> $LOG

fi
