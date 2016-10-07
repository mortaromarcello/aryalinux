#!/bin/bash

set -e
set +h

. /sources/build-properties

export MAKEFLAGS="-j `nproc`"
SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="091-grub.sh"
TARBALL="grub-2.02~beta3.tar.xz"

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

if [ "$TARBALL" != "" ]
then
	DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`
	tar xf $TARBALL
	cd $DIRECTORY
fi

sed -i "s@GNU GRUB  version %s@$OS_NAME $OS_VERSION $OS_CODENAME \- GNU GRUB@g" grub-core/normal/main.c

if [ -d /sys/firmware/efi ]
then
./configure --prefix=/usr  \
	--sbindir=/sbin        \
	--sysconfdir=/etc      \
	--disable-grub-emu-usb \
	--disable-efiemu       \
	--enable-grub-mkfont   \
	--with-platform=efi    \
	--target=x86_64        \
	--program-prefix=""    \
	--with-bootdir="/boot" \
	--with-grubdir="grub"  \
	--disable-werror 
else
./configure --prefix=/usr          \
            --sbindir=/sbin        \
            --sysconfdir=/etc      \
            --disable-grub-emu-usb \
            --disable-efiemu       \
            --disable-werror
fi
make
make install

if [ -d /sys/firmware/efi ]
then
	mkdir -pv /usr/share/fonts/unifont
	gunzip -c ../unifont-7.0.05.pcf.gz > /usr/share/fonts/unifont/unifont.pcf
	grub-mkfont -o /usr/share/grub/unicode.pf2 \
		 /usr/share/fonts/unifont/unifont.pcf
fi

cd $SOURCE_DIR
if [ "$TARBALL" != "" ]
then
	rm -rf $DIRECTORY
	rm -rf {gcc,glibc,binutils}-build
fi

echo "$STEPNAME" | tee -a $LOGFILE

fi
