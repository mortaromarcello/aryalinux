#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=linux-3.14.21.tar.xz

if ! grep 106-linux $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


make mrproper
make headers_check
make INSTALL_HDR_PATH=/usr headers_install
find /usr/include -name .install -or -name ..install.cmd | xargs rm -fv

cd $SOURCE_DIR
rm -rf $DIR
echo 106-linux >> $LOG

fi
