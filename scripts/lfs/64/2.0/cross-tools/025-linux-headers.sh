#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/mnt/clfs/sources
export LOG=/mnt/clfs/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=linux-3.14.21.tar.xz

if ! grep 026-linux $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


#xzcat ../patch-3.14.21.xz | patch -Np1 -i -

make mrproper
make ARCH=x86_64 headers_check
make ARCH=x86_64 INSTALL_HDR_PATH=/tools headers_install

cd $SOURCE_DIR
rm -rf $DIR
echo 026-linux >> $LOG

fi
