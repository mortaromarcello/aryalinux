#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=iana-etc-2.30.tar.bz2

if ! grep 132-iana-etc $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


xzcat ../iana-etc-2.30-numbers_update-20140202-2.patch.xz | patch -Np1 -i -

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 132-iana-etc >> $LOG

fi
