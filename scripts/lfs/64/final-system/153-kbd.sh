#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=kbd-2.0.1.tar.xz

if ! grep 154-kbd $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


PKG_CONFIG_PATH="/tools/lib/pkgconfig" \
    ./configure --prefix=/usr --disable-vlock --enable-optional-progs

make "-j`nproc`"

make install

mv -v /usr/bin/{loadkeys,setfont} /bin

mkdir -v /usr/share/doc/kbd-2.0.1
cp -R -v docs/doc/* /usr/share/doc/kbd-2.0.1

cd $SOURCE_DIR
rm -rf $DIR
echo 154-kbd >> $LOG

fi
