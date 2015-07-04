#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/mnt/clfs/sources
export LOG=/mnt/clfs/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=patch-3.14.21.xz

if ! grep 062-patch $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/tools \
    --build=${CLFS_HOST} --host=${CLFS_TARGET}

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 062-patch >> $LOG

fi
