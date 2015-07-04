#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=bzip2-1.0.6.tar.gz

if ! grep 135-bzip2 $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


sed -i -e 's:ln -s -f $(PREFIX)/bin/:ln -s :' Makefile

sed -i 's@X)/man@X)/share/man@g' ./Makefile

make -f Makefile-libbz2_so
make clean

make "-j`nproc`"

make PREFIX=/usr install

cp -v bzip2-shared /bin/bzip2
cp -av libbz2.so* /lib
ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so
rm -v /usr/bin/{bunzip2,bzcat,bzip2}
ln -sv bzip2 /bin/bunzip2
ln -sv bzip2 /bin/bzcat

cd $SOURCE_DIR
rm -rf $DIR
echo 135-bzip2 >> $LOG

fi
