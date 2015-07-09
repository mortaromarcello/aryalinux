#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=mpfr-3.1.2.tar.xz

if ! grep 112-mpfr $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


patch -Np1 -i ../mpfr-3.1.2-fixes-4.patch

CC="gcc -isystem /usr/include" \
    LDFLAGS="-Wl,-rpath-link,/usr/lib:/lib" \
    ./configure --prefix=/usr --with-gmp=/usr \
    --docdir=/usr/share/doc/mpfr-3.1.2

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 112-mpfr >> $LOG

fi
