#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/mnt/clfs/sources
export LOG=/mnt/clfs/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=gmp-6.0.0a.tar.xz

if ! grep 030-gmp $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/cross-tools --enable-cxx \
    --disable-static

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 030-gmp >> $LOG

fi
