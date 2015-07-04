#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=sed-4.2.2.tar.bz2

if ! grep 123-sed $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/usr --bindir=/bin \
    --docdir=/usr/share/doc/sed-4.2.2

make "-j`nproc`"

make html

make install

make -C doc install-html

cd $SOURCE_DIR
rm -rf $DIR
echo 123-sed >> $LOG

fi
