#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/mnt/clfs/sources
export LOG=/mnt/clfs/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=ncurses-5.9.tar.gz

if ! grep 028-ncurses $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


patch -Np1 -i ../ncurses-5.9-bash_fix-1.patch

./configure --prefix=/cross-tools \
    --without-debug --without-shared

make -C include
make -C progs tic

install -v -m755 progs/tic /cross-tools/bin

cd $SOURCE_DIR
rm -rf $DIR
echo 028-ncurses >> $LOG

fi
