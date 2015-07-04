#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=man-pages-3.68.tar.xz

if ! grep 107-man-pages $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


make install

cd $SOURCE_DIR
rm -rf $DIR
echo 107-man-pages >> $LOG

fi
