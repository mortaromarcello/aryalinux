#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=expat-2.1.0.tar.gz

if ! grep 159-expat $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/usr

make "-j`nproc`"

make install

install -v -m755 -d /usr/share/doc/expat-2.1.0
install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.1.0

cd $SOURCE_DIR
rm -rf $DIR
echo 159-expat >> $LOG

fi
