#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=ncurses-5.9.tar.gz

if ! grep 125-ncurses $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


patch -Np1 -i ../ncurses-5.9-branch_update-4.patch

./configure --prefix=/usr --libdir=/lib \
    --with-shared --without-debug --enable-widec \
    --with-manpage-format=normal --enable-pc-files \
    --with-default-terminfo-dir=/usr/share/terminfo

make "-j`nproc`"

make install

mv -v /lib/lib{panelw,menuw,formw,ncursesw,ncurses++w}.a /usr/lib

ln -svf ../../lib/$(readlink /lib/libncursesw.so) /usr/lib/libncursesw.so
ln -svf ../../lib/$(readlink /lib/libmenuw.so) /usr/lib/libmenuw.so
ln -svf ../../lib/$(readlink /lib/libpanelw.so) /usr/lib/libpanelw.so
ln -svf ../../lib/$(readlink /lib/libformw.so) /usr/lib/libformw.so
rm -v /lib/lib{ncursesw,menuw,panelw,formw}.so

for lib in curses ncurses form panel menu ; do
        echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
        ln -sfv lib${lib}w.a /usr/lib/lib${lib}.a
done
ln -sfv libncursesw.so /usr/lib/libcursesw.so
ln -sfv libncursesw.a /usr/lib/libcursesw.a
ln -sfv libncurses++w.a /usr/lib/libncurses++.a
ln -sfv ncursesw5-config /usr/bin/ncurses5-config

cd $SOURCE_DIR
rm -rf $DIR
echo 125-ncurses >> $LOG

fi
