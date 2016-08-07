#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:upower:0.99.4

#REQ:dbus-glib
#REQ:libgudev
#REQ:libusb
#REQ:polkit
#OPT:gobject-introspection
#OPT:gtk-doc
#OPT:python3


cd $SOURCE_DIR

URL=http://upower.freedesktop.org/releases/upower-0.99.4.tar.xz

wget -nc http://upower.freedesktop.org/releases/upower-0.99.4.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/upower/upower-0.99.4.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/upower/upower-0.99.4.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/upower/upower-0.99.4.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/upower/upower-0.99.4.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/upower/upower-0.99.4.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --enable-deprecated  \
            --disable-static     &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable upower

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "upower=>`date`" | sudo tee -a $INSTALLED_LIST

