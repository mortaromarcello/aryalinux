#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=automake-1.14.1.tar.xz

if ! grep 140-automake $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.14.1

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 140-automake >> $LOG

fi
