#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/mnt/clfs/sources
export LOG=/mnt/clfs/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=util-linux-2.24.2.tar.xz

if ! grep 066-util-linux $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/tools \
    --build=${CLFS_HOST} --host=${CLFS_TARGET} \
    --disable-makeinstall-chown --disable-makeinstall-setuid

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 066-util-linux >> $LOG

fi
