#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=gperf-3.0.4.tar.gz

if ! grep 148-gperf $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.0.4

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 148-gperf >> $LOG

fi
