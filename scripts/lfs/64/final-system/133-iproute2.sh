#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=iproute2-3.14.0.tar.xz

if ! grep 134-iproute2 $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


sed -i '/^TARGETS/s@arpd@@g' misc/Makefile
sed -i '/ARPD/d' Makefile
sed -i 's/arpd.8//' man/man8/Makefile

make "-j`nproc`"

make DOCDIR=/usr/share/doc/iproute2-3.14.0 install

cd $SOURCE_DIR
rm -rf $DIR
echo 134-iproute2 >> $LOG

fi
