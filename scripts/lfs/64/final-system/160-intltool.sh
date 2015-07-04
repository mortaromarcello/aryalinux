#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=intltool-0.50.2.tar.gz

if ! grep 161-intltool $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/usr

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 161-intltool >> $LOG

fi
