#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:usbutils:008

#REQ:libusb
#REQ:python2


cd $SOURCE_DIR

URL=http://ftp.kernel.org/pub/linux/utils/usb/usbutils/usbutils-008.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/usbutils/usbutils-008.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/usbutils/usbutils-008.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/usbutils/usbutils-008.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/usbutils/usbutils-008.tar.xz || wget -nc ftp://ftp.kernel.org/pub/linux/utils/usb/usbutils/usbutils-008.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/usbutils/usbutils-008.tar.xz || wget -nc http://ftp.kernel.org/pub/linux/utils/usb/usbutils/usbutils-008.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

sed -i '/^usbids/ s:usb.ids:hwdata/&:' lsusb.py &&
./configure --prefix=/usr --datadir=/usr/share/hwdata &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -dm755 /usr/share/hwdata/ &&
wget http://www.linux-usb.org/usb.ids -O /usr/share/hwdata/usb.ids

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
wget http://www.linux-usb.org/usb.ids -O /usr/share/hwdata/usb.ids

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "usbutils=>`date`" | sudo tee -a $INSTALLED_LIST

