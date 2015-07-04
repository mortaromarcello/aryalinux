#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=iputils-s20121221.tar.bz2

if ! grep 153-iputils $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


patch -Np1 -i ../iputils-s20121221-fixes-2.patch

make \
    IPV4_TARGETS="tracepath ping clockdiff rdisc" \
    IPV6_TARGETS="tracepath6 traceroute6"

install -v -m755 ping /bin
install -v -m755 clockdiff /usr/bin
install -v -m755 rdisc /usr/bin
install -v -m755 tracepath /usr/bin
install -v -m755 trace{path,route}6 /usr/bin
install -v -m644 doc/*.8 /usr/share/man/man8

cd $SOURCE_DIR
rm -rf $DIR
echo 153-iputils >> $LOG

fi
