#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=make-4.0.tar.bz2

if ! grep 157-make $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/usr

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 157-make >> $LOG

fi
