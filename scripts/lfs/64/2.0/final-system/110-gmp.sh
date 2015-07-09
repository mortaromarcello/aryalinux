#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=gmp-6.0.0a.tar.xz

if ! grep 111-gmp $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


CC="gcc -isystem /usr/include" \
CXX="g++ -isystem /usr/include" \
LDFLAGS="-Wl,-rpath-link,/usr/lib:/lib" \
  ./configure --prefix=/usr --enable-cxx \
  --docdir=/usr/share/doc/gmp-6.0.0

make "-j`nproc`"

make html

make install

make install-html

cd $SOURCE_DIR
rm -rf $DIR
echo 111-gmp >> $LOG

fi
