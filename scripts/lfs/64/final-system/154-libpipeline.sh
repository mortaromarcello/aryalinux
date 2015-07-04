#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=libpipeline-1.3.0.tar.gz

if ! grep 155-libpipeline $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 155-libpipeline >> $LOG

fi
