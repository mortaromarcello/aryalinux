#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/mnt/clfs/sources
export LOG=/mnt/clfs/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=bzip2-1.0.6.tar.gz

if ! grep 051-bzip2 $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


cp -v Makefile{,.orig}
sed -e 's@^\(all:.*\) test@\1@g' Makefile.orig > Makefile

make CC="${CC}" AR="${AR}" RANLIB="${RANLIB}"

make PREFIX=/tools install

cd $SOURCE_DIR
rm -rf $DIR
echo 051-bzip2 >> $LOG

fi
