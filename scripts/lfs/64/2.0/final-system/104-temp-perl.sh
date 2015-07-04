#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=perl-5.20.0.tar.bz2

if ! grep 105-perl $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


sed -i 's@/usr/include@/tools/include@g' ext/Errno/Errno_pm.PL

./configure.gnu --prefix=/tools -Dcc="gcc"

make "-j`nproc`"

make install

ln -sfv /tools/bin/perl /usr/bin

cd $SOURCE_DIR
rm -rf $DIR
echo 105-perl >> $LOG

fi
