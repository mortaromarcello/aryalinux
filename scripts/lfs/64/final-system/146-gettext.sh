#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=gettext-0.19.1.tar.gz

if ! grep 147-gettext $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/usr --docdir=/usr/share/doc/gettext-0.19.1

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 147-gettext >> $LOG

fi
