#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=systemd-213.tar.xz

if ! grep 165-systemd $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


patch -Np1 -i ../systemd-213-compat-1.patch

sed -i '/virt-install-hook /d' Makefile.in

sed -i '/timesyncd.conf/d' src/timesync/timesyncd.conf.in

sed -i '/-l/d' src/fsck/fsck.c

./configure --prefix=/usr \
    --sysconfdir=/etc --localstatedir=/var \
    --libexecdir=/usr/lib --docdir=/usr/share/doc/systemd-213 \
    --with-rootprefix="" --with-rootlibdir=/lib \
    --enable-split-usr --disable-gudev --with-kbd-loadkeys=/bin/loadkeys \
    --with-kbd-setfont=/bin/setfont --with-dbuspolicydir=/etc/dbus-1/system.d \
    --with-dbusinterfacedir=/usr/share/dbus-1/interfaces \
    --with-dbussessionservicedir=/usr/share/dbus-1/services \
    --with-dbussystemservicedir=/usr/share/dbus-1/system-services \
    cc_cv_CFLAGS__flto=no

make "-j`nproc`"

sed -e "s:test/udev-test.pl::g" \
    -e "s:test-bus-cleanup\$(EXEEXT) ::g" \
    -e "s:test-bus-gvariant\$(EXEEXT) ::g" \
    -i Makefile

make install

install -v -m644 man/*.html /usr/share/doc/systemd-213

mv -v /usr/lib/libnss_myhostname.so.2 /lib

rm -rfv /usr/lib/rpm

for tool in runlevel reboot shutdown poweroff halt telinit; do
  ln -sfv ../bin/systemctl /sbin/$tool
done
ln -sfv ../lib/systemd/systemd /sbin/init

sed -i "s@root lock@root root@g" /usr/lib/tmpfiles.d/legacy.conf

systemd-machine-id-setup

cat > /etc/os-release << "EOF"
# Begin /etc/os-release

NAME=Cross-LFS
ID=clfs

PRETTY_NAME=Cross Linux From Scratch
ANSI_COLOR=0;33

VERSION=3.0.0-SYSTEMD
VERSION_ID=20141018

# End /etc/os-release
EOF

cd $SOURCE_DIR
rm -rf $DIR
echo 165-systemd >> $LOG

fi
