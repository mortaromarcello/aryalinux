#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/mnt/clfs/sources
export LOG=/mnt/clfs/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=glibc-2.19.tar.xz

if ! grep 037-glibc $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


cp -v timezone/Makefile{,.orig}
sed 's/\\$$(pwd)/`pwd`/' timezone/Makefile.orig > timezone/Makefile

mkdir -v ../glibc-build
cd ../glibc-build

echo "libc_cv_ssp=no" > config.cache

BUILD_CC="gcc" CC="${CLFS_TARGET}-gcc ${BUILD64}" \
      AR="${CLFS_TARGET}-ar" RANLIB="${CLFS_TARGET}-ranlib" \
      ../glibc-2.19/configure --prefix=/tools \
      --host=${CLFS_TARGET} --build=${CLFS_HOST} \
      --disable-profile --enable-kernel=2.6.32 \
      --with-binutils=/cross-tools/bin --with-headers=/tools/include \
      --enable-obsolete-rpc --cache-file=config.cache

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 037-glibc >> $LOG

fi
