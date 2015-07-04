#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=gawk-4.1.1.tar.xz

if ! grep 145-gawk $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/usr --libexecdir=/usr/lib

make "-j`nproc`"

make install

mkdir -v /usr/share/doc/gawk-4.1.1
cp -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-4.1.1

cd $SOURCE_DIR
rm -rf $DIR
echo 145-gawk >> $LOG

fi
