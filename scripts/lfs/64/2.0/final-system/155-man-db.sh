#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=man-db-2.6.7.1.tar.xz

if ! grep 156-man-db $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/usr --libexecdir=/usr/lib \
    --docdir=/usr/share/doc/man-db-2.6.7.1 --sysconfdir=/etc \
    --disable-setuid --with-browser=/usr/bin/lynx \
    --with-vgrind=/usr/bin/vgrind --with-grap=/usr/bin/grap

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 156-man-db >> $LOG

fi
