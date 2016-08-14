#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:syslinux:6.03

cd $SOURCE_DIR

URL=https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.xz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

if [ `uname -m` != "x86_64" ]
then
	sed -i "s@efi32 efi64@efi32@g" Makefile
fi
make &&
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "syslinux=>`date`" | sudo tee -a $INSTALLED_LIST


