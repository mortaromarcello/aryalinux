#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=bc-1.06.95.tar.bz2

if ! grep 142-bc $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/usr --with-readline \
    --mandir=/usr/share/man --infodir=/usr/share/info

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 142-bc >> $LOG

fi
