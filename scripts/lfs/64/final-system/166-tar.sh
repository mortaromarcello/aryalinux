#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=tar-1.27.1.tar.xz

if ! grep 167-tar $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


patch -Np1 -i ../tar-1.27.1-manpage-1.patch

FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr \
    --bindir=/bin --libexecdir=/usr/sbin

make "-j`nproc`"

make install

perl tarman > /usr/share/man/man1/tar.1

make -C doc install-html docdir=/usr/share/doc/tar-1.27.1

cd $SOURCE_DIR
rm -rf $DIR
echo 167-tar >> $LOG

fi
