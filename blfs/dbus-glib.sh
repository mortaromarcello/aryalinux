#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:dbus-glib:0.106

#REQ:dbus
#REQ:glib2
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.106.tar.gz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/dbus-glib/dbus-glib-0.106.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/dbus-glib/dbus-glib-0.106.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/dbus-glib/dbus-glib-0.106.tar.gz || wget -nc http://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.106.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/dbus-glib/dbus-glib-0.106.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/dbus-glib/dbus-glib-0.106.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "dbus-glib=>`date`" | sudo tee -a $INSTALLED_LIST

