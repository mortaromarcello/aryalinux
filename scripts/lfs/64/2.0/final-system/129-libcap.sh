#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=libcap-2.24.tar.xz

if ! grep 130-libcap $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


make "-j`nproc`"

make RAISE_SETFCAP=no install
chmod -v 755 /lib/libcap.so.2.24
ln -sfv ../../lib/$(readlink /lib/libcap.so) /usr/lib/libcap.so
rm -v /lib/libcap.so
mv -v /lib/libcap.a /usr/lib

cd $SOURCE_DIR
rm -rf $DIR
echo 130-libcap >> $LOG

fi
