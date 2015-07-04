#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=mpc-1.0.2.tar.gz

if ! grep 113-mpc $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


CC="gcc -isystem /usr/include" \
LDFLAGS="-Wl,-rpath-link,/usr/lib:/lib" \
  ./configure --prefix=/usr --docdir=/usr/share/doc/mpc-1.0.2

make "-j`nproc`"

make html

make install

make install-html

cd $SOURCE_DIR
rm -rf $DIR
echo 113-mpc >> $LOG

fi
