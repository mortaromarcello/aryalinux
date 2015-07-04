#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=readline-6.3.tar.gz

if ! grep 138-readline $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


patch -Np1 -i ../readline-6.3-branch_update-4.patch

./configure --prefix=/usr --libdir=/lib \
    --docdir=/usr/share/doc/readline-6.3

make SHLIB_LIBS=-lncurses

make SHLIB_LIBS=-lncurses htmldir=/usr/share/doc/readline-6.3 install

mv -v /lib/lib{readline,history}.a /usr/lib

ln -svf ../../lib/$(readlink /lib/libreadline.so) /usr/lib/libreadline.so
ln -svf ../../lib/$(readlink /lib/libhistory.so) /usr/lib/libhistory.so
rm -v /lib/lib{readline,history}.so

cd $SOURCE_DIR
rm -rf $DIR
echo 138-readline >> $LOG

fi
