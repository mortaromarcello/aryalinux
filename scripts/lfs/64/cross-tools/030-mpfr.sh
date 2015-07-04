#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/mnt/clfs/sources
export LOG=/mnt/clfs/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=mpfr-3.1.2.tar.xz

if ! grep 031-mpfr $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


patch -Np1 -i ../mpfr-3.1.2-fixes-4.patch

LDFLAGS="-Wl,-rpath,/cross-tools/lib" \
./configure --prefix=/cross-tools \
    --disable-static --with-gmp=/cross-tools

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 031-mpfr >> $LOG

fi
