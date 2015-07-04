#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=zlib-1.2.8.tar.xz

if ! grep 116-zlib $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


CC="gcc -isystem /usr/include" \
CXX="g++ -isystem /usr/include" \
LDFLAGS="-Wl,-rpath-link,/usr/lib:/lib" \
  ./configure --prefix=/usr

make "-j`nproc`"

make install

mv -v /usr/lib/libz.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so

mkdir -pv /usr/share/doc/zlib-1.2.8
cp -rv doc/* examples /usr/share/doc/zlib-1.2.8

cd $SOURCE_DIR
rm -rf $DIR
echo 116-zlib >> $LOG

fi
