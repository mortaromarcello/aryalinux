#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=gdbm-1.11.tar.gz

if ! grep 136-gdbm $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/usr --enable-libgdbm-compat

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 136-gdbm >> $LOG

fi
