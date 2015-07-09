#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=xz-5.0.5.tar.xz

if ! grep 158-xz $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/usr --docdir=/usr/share/doc/xz-5.0.5

make "-j`nproc`"

make install

mv -v /usr/bin/{xz,lzma,lzcat,unlzma,unxz,xzcat} /bin

mv -v /usr/lib/liblzma.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so

cd $SOURCE_DIR
rm -rf $DIR
echo 158-xz >> $LOG

fi
