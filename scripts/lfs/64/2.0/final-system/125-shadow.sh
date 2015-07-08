#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=shadow-4.2.1.tar.xz

if ! grep 126-shadow $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


sed -i 's@\(DICTPATH.\).*@\1/lib/cracklib/pw_dict@' etc/login.defs

sed -i src/Makefile.in \
  -e 's/groups$(EXEEXT) //' -e 's/= nologin$(EXEEXT)/= /'
find man -name Makefile.in -exec sed -i \
  -e 's/man1\/groups\.1 //' -e 's/man8\/nologin\.8 //' '{}' \;

./configure --sysconfdir=/etc

make "-j`nproc`"

make install

sed -i /etc/login.defs \
    -e 's@#\(ENCRYPT_METHOD \).*@\1SHA512@' \
    -e 's@/var/spool/mail@/var/mail@'

mv -v /usr/bin/passwd /bin

touch /var/log/lastlog
chgrp -v utmp /var/log/lastlog
chmod -v 664 /var/log/lastlog

pwconv

grpconv

cd $SOURCE_DIR
rm -rf $DIR
echo 126-shadow >> $LOG

fi
