#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=bash-4.3.tar.gz

if ! grep 141-bash $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


patch -Np1 -i ../bash-4.3-branch_update-5.patch

./configure --prefix=/usr --bindir=/bin \
    --without-bash-malloc --with-installed-readline \
    --docdir=/usr/share/doc/bash-4.3

make "-j`nproc`"

make install

cd $SOURCE_DIR
rm -rf $DIR
echo 141-bash >> $LOG

fi
