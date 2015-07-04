#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=acl-2.2.52.src.tar.gz

if ! grep 122-acl $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in

sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test

./configure --prefix=/usr --libexecdir=/usr/lib

make "-j`nproc`"

make install install-dev install-lib

mv -v /usr/lib/libacl.so.* /lib
ln -sfv ../../lib/libacl.so.1 /usr/lib/libacl.so

chmod 755 -v /lib/libacl.so.1.1.0

cd $SOURCE_DIR
rm -rf $DIR
echo 122-acl >> $LOG

fi
