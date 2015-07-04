#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=findutils-4.4.2.tar.gz

if ! grep 146-findutils $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/usr --libexecdir=/usr/lib/locate \
    --localstatedir=/var/lib/locate

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 146-findutils >> $LOG

fi
