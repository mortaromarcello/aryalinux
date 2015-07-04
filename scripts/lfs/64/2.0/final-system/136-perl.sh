#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=perl-5.20.0.tar.bz2

if ! grep 137-perl $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


export BUILD_ZLIB=False
export BUILD_BZIP2=0

ip link set lo up

echo "127.0.0.1 localhost $(hostname)" > /etc/hosts

./configure.gnu --prefix=/usr \
   -Dvendorprefix=/usr \
   -Dman1dir=/usr/share/man/man1 \
   -Dman3dir=/usr/share/man/man3 \
   -Dpager="/bin/less -isR" \
   -Dusethreads -Duseshrplib

make "-j`nproc`"

make install
unset BUILD_ZLIB BUILD_BZIP2

cd $SOURCE_DIR
rm -rf $DIR
echo 137-perl >> $LOG

fi
