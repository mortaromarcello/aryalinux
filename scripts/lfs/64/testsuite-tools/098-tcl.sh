#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=tcl8.6.1-src.tar.gz

if ! grep 099-tcl $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


sed -i s/500/5000/ generic/regc_nfa.c

cd unix
./configure --prefix=/tools

make "-j`nproc`"

make install

make install-private-headers

ln -sv tclsh8.6 /tools/bin/tclsh

cd $SOURCE_DIR
rm -rf $DIR
echo 099-tcl >> $LOG

fi
