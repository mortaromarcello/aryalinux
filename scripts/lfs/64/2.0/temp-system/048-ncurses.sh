#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/mnt/clfs/sources
export LOG=/mnt/clfs/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=ncurses-5.9.tar.gz

if ! grep 049-ncurses $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


patch -Np1 -i ../ncurses-5.9-bash_fix-1.patch

./configure --prefix=/tools --with-shared \
    --build=${CLFS_HOST} --host=${CLFS_TARGET} \
    --without-debug --without-ada \
    --enable-overwrite --with-build-cc=gcc

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 049-ncurses >> $LOG

fi
