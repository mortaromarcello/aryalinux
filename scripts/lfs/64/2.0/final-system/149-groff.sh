#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=groff-1.22.2.tar.gz

if ! grep 150-groff $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


PAGE=$PAPER_SIZE ./configure --prefix=/usr

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 150-groff >> $LOG

fi
