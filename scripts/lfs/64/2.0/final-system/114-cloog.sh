#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=cloog-0.18.2.tar.gz

if ! grep 115-cloog $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


CC="gcc -isystem /usr/include" \
LDFLAGS="-Wl,-rpath-link,/usr/lib:/lib" \
  ./configure --prefix=/usr --with-isl=system

sed -i '/cmake/d' Makefile

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 115-cloog >> $LOG

fi
