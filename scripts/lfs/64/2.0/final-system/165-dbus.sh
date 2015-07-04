#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=dbus-1.8.6.tar.gz

if ! grep 166-dbus $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/usr --sysconfdir=/etc \
    --libexecdir=/usr/lib/dbus-1.0 --localstatedir=/var \
    --with-systemdsystemunitdir=/lib/systemd/system \
    --docdir=/usr/share/doc/dbus-1.8.6

make "-j`nproc`"

make install

mv -v /usr/lib/libdbus-1.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libdbus-1.so) /usr/lib/libdbus-1.so

ln -sv /etc/machine-id /var/lib/dbus

cd $SOURCE_DIR
rm -rf $DIR
echo 166-dbus >> $LOG

fi
