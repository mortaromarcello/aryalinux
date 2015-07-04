#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=util-linux-2.24.2.tar.xz

if ! grep 127-util-linux $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


sed -i -e 's@etc/adjtime@var/lib/hwclock/adjtime@g' \
    $(grep -rl '/etc/adjtime' .)
mkdir -pv /var/lib/hwclock

./configure --enable-write --docdir=/usr/share/doc/util-linux-2.24.2

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 127-util-linux >> $LOG

fi
