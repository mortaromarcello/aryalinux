#!/bin/bash

set -e
set +h

export SOURCE_DIR="/sources"
export LOG_PATH="/sources/build.log"

export STEP_NAME="06-openssl"
export TARBALL="openssl-1.0.2d.tar.gz"
export DIRECTORY="openssl-1.0.2d"

touch $LOG_PATH
cd $SOURCE_DIR

if ! grep "$STEP_NAME" $LOG_PATH
then

tar -xf $TARBALL
cd $DIRECTORY

./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic &&
make "-j`nproc`"

sed -i 's# libcrypto.a##;s# libssl.a##' Makefile

make MANDIR=/usr/share/man MANSUFFIX=ssl install &&
install -dv -m755 /usr/share/doc/openssl-1.0.2  &&
cp -vfr doc/*     /usr/share/doc/openssl-1.0.2

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEP_NAME" >> $LOG_PATH

fi

