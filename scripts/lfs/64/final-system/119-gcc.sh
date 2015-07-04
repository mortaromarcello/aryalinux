#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=gcc-4.8.3.tar.bz2

if ! grep 120-gcc $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


patch -Np1 -i ../gcc-4.8.3-branch_update-1.patch

patch -Np1 -i ../gcc-4.8.3-pure64-1.patch

sed -i 's@\./fixinc\.sh@-c true@' gcc/Makefile.in

mkdir -v ../gcc-build
cd ../gcc-build

SED=sed CC="gcc -isystem /usr/include" \
CXX="g++ -isystem /usr/include" \
LDFLAGS="-Wl,-rpath-link,/usr/lib:/lib" \
  ../gcc-4.8.3/configure --prefix=/usr \
    --libexecdir=/usr/lib --enable-threads=posix \
    --enable-__cxa_atexit --enable-clocale=gnu --enable-languages=c,c++ \
    --disable-multilib --disable-libstdcxx-pch \
    --with-system-zlib --enable-checking=release --enable-libstdcxx-time

make "-j`nproc`"

make install

cp -v ../gcc-4.8.3/include/libiberty.h /usr/include

ln -sv ../usr/bin/cpp /lib

ln -sv gcc /usr/bin/cc

mv -v /usr/lib/libstdc++*gdb.py /usr/share/gdb/auto-load/usr/lib

cd $SOURCE_DIR
rm -rf $DIR
rm -rf gcc-build

echo 120-gcc >> $LOG

fi
