#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=pkg-config-lite-0.28-1.tar.gz

if ! grep 124-pkg-config-lite $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/usr --docdir=/usr/share/doc/pkg-config-0.28-1

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 124-pkg-config-lite >> $LOG

fi
