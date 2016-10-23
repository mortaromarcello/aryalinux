#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The USB Utils package containsbr3ak utilities used to display information about USB buses in the systembr3ak and the devices connected to them.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:libusb
#REQ:python2


#VER:usbutils:008


NAME="usbutils"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/usbutils/usbutils-008.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/usbutils/usbutils-008.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/usbutils/usbutils-008.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/usbutils/usbutils-008.tar.xz || wget -nc http://ftp.kernel.org/pub/linux/utils/usb/usbutils/usbutils-008.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/usbutils/usbutils-008.tar.xz || wget -nc ftp://ftp.kernel.org/pub/linux/utils/usb/usbutils/usbutils-008.tar.xz


URL=http://ftp.kernel.org/pub/linux/utils/usb/usbutils/usbutils-008.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

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

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST