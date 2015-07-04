#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/mnt/clfs/sources
export LOG=/mnt/clfs/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=pkg-config-lite-0.28-1.tar.gz

if ! grep 029-pkg-config-lite $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/cross-tools --host=${CLFS_TARGET}\
    --with-pc-path=/tools/lib/pkgconfig:/tools/share/pkgconfig

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 029-pkg-config-lite >> $LOG

fi
