#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/mnt/clfs/sources
export LOG=/mnt/clfs/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=m4-1.4.17.tar.xz

if ! grep 027-m4 $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/cross-tools

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 027-m4 >> $LOG

fi
