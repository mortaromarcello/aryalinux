#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=gzip-1.6.tar.xz

if ! grep 152-gzip $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/usr --bindir=/bin

make "-j`nproc`"

make install

mv -v /bin/z{egrep,cmp,diff,fgrep,force,grep,less,more,new} /usr/bin

cd $SOURCE_DIR
rm -rf $DIR
echo 152-gzip >> $LOG

fi
