#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libusb
#DEP:python2


cd $SOURCE_DIR

wget -nc http://ftp.kernel.org/pub/linux/utils/usb/usbutils/usbutils-008.tar.xz
wget -nc ftp://ftp.kernel.org/pub/linux/utils/usb/usbutils/usbutils-008.tar.xz


TARBALL=usbutils-008.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i '/^usbids/ s:usb.ids:misc/&:' lsusb.py &&

./configure --prefix=/usr --datadir=/usr/share/misc &&
make

cat > 1434987998773.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998773.sh
sudo ./1434987998773.sh
sudo rm -rf 1434987998773.sh

cat > 1434987998773.sh << "ENDOFFILE"
wget http://www.linux-usb.org/usb.ids -O /usr/share/misc/usb.ids
ENDOFFILE
chmod a+x 1434987998773.sh
sudo ./1434987998773.sh
sudo rm -rf 1434987998773.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "usbutils=>`date`" | sudo tee -a $INSTALLED_LIST