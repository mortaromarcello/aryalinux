#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=dejagnu-1.5.1.tar.gz

if ! grep 101-dejagnu $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/tools

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 101-dejagnu >> $LOG

fi
