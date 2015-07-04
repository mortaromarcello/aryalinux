#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=procps-ng-3.3.9.tar.xz

if ! grep 128-procps-ng $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


./configure --prefix=/usr --exec-prefix= \
    --libdir=/usr/lib --docdir=/usr/share/doc/procps-ng-3.3.9 \
    --disable-kill

make "-j`nproc`"

hostname clfs

sed -i -r 's|(pmap_initname)\\\$|\1|' testsuite/pmap.test/pmap.exp
make install

mv -v /usr/bin/pidof /bin
mv -v /usr/lib/libprocps.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so

cd $SOURCE_DIR
rm -rf $DIR
echo 128-procps-ng >> $LOG

fi
