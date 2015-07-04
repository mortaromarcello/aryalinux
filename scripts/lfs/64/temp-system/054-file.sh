#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/mnt/clfs/sources
export LOG=/mnt/clfs/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=file-5.19.tar.gz

if ! grep 055-file $LOG
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
echo 055-file >> $LOG

fi
