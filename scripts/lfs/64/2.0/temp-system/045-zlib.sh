#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/mnt/clfs/sources
export LOG=/mnt/clfs/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=zlib-1.2.8.tar.xz

if ! grep 046-zlib $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/tools

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 046-zlib >> $LOG

fi
