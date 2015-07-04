#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=kmod-18.tar.xz

if ! grep 162-kmod $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/usr \
    --bindir=/bin --sysconfdir=/etc \
    --with-rootlibdir=/lib \
    --with-zlib --with-xz

make "-j`nproc`"

make install

ln -sfv kmod /bin/lsmod
for tool in depmod insmod modinfo modprobe rmmod; do
    ln -sfv ../bin/kmod /sbin/${tool}
done

cd $SOURCE_DIR
rm -rf $DIR
echo 162-kmod >> $LOG

fi
