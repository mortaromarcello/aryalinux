#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=attr-2.4.47.src.tar.gz

if ! grep 121-attr $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in

./configure --prefix=/usr

make "-j`nproc`"

make install install-dev install-lib

mv -v /usr/lib/libattr.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so

chmod 755 -v /lib/libattr.so.1.1.0

cd $SOURCE_DIR
rm -rf $DIR
echo 121-attr >> $LOG

fi
