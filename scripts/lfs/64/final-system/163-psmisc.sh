#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=psmisc-22.21.tar.gz

if ! grep 164-psmisc $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/usr

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 164-psmisc >> $LOG

fi
