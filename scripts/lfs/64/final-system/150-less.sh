#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=less-462.tar.gz

if ! grep 151-less $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/usr --sysconfdir=/etc

make "-j`nproc`"

make install

mv -v /usr/bin/less /bin

cd $SOURCE_DIR
rm -rf $DIR
echo 151-less >> $LOG

fi
