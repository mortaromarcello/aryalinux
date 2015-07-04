#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/mnt/clfs/sources
export LOG=/mnt/clfs/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=isl-0.12.2.tar.lzma

if ! grep 033-isl $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


LDFLAGS="-Wl,-rpath,/cross-tools/lib" \
./configure --prefix=/cross-tools --disable-static \
    --with-gmp-prefix=/cross-tools

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 033-isl >> $LOG

fi
