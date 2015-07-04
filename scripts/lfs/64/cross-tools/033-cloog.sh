#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/mnt/clfs/sources
export LOG=/mnt/clfs/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=cloog-0.18.2.tar.gz

if ! grep 034-cloog $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


LDFLAGS="-Wl,-rpath,/cross-tools/lib" \
    ./configure --prefix=/cross-tools --disable-static \
    --with-gmp-prefix=/cross-tools --with-isl-prefix=/cross-tools

cp -v Makefile{,.orig}
sed '/cmake/d' Makefile.orig > Makefile

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 034-cloog >> $LOG

fi
