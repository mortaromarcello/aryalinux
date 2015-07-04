#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/mnt/clfs/sources
export LOG=/mnt/clfs/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=cloog-0.18.2.tar.gz

if ! grep 045-cloog $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/tools \
    --build=${CLFS_HOST} --host=${CLFS_TARGET} \
    --with-isl=system

cp -v Makefile{,.orig}
sed '/cmake/d' Makefile.orig > Makefile

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 045-cloog >> $LOG

fi
