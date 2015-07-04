#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=expect5.45.tar.gz

if ! grep 100-expect $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/tools --with-tcl=/tools/lib \
    --with-tclinclude=/tools/include

make "-j`nproc`"

make SCRIPTS="" install

cd $SOURCE_DIR
rm -rf $DIR
echo 100-expect >> $LOG

fi
