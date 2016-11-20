#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The USB Utils package containsbr3ak utilities used to display information about USB buses in the systembr3ak and the devices connected to them.br3ak"
SECTION="general"
VERSION=008
NAME="usbutils"

#REQ:libusb
#REQ:python2


cd $SOURCE_DIR

URL=http://ftp.kernel.org/pub/linux/utils/usb/usbutils/usbutils-008.tar.xz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/usbutils/usbutils-008.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/usbutils/usbutils-008.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/usbutils/usbutils-008.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/usbutils/usbutils-008.tar.xz || wget -nc http://ftp.kernel.org/pub/linux/utils/usb/usbutils/usbutils-008.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/usbutils/usbutils-008.tar.xz || wget -nc ftp://ftp.kernel.org/pub/linux/utils/usb/usbutils/usbutils-008.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

sed -i '/^usbids/ s:usb.ids:hwdata/&:' lsusb.py &&
./configure --prefix=/usr --datadir=/usr/share/hwdata &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -dm755 /usr/share/hwdata/ &&
pushd $SOURCE_DIR && wget -nc http://www.linux-usb.org/usb.ids && cp -v usb.ids /usr/share/hwdata/usb.ids && popd

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
pushd $SOURCE_DIR && wget -nc http://www.linux-usb.org/usb.ids && cp -v usb.ids /usr/share/hwdata/usb.ids && popd

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
