#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gsettings-desktop-schemas:3.18.1

#REQ:glib2
#REC:gobject-introspection


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gsettings-desktop-schemas/3.18/gsettings-desktop-schemas-3.18.1.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gsettings-desktop-schemas/gsettings-desktop-schemas-3.18.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gsettings-desktop-schemas/3.18/gsettings-desktop-schemas-3.18.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gsettings-desktop-schemas/gsettings-desktop-schemas-3.18.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gsettings-desktop-schemas/gsettings-desktop-schemas-3.18.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gsettings-desktop-schemas/gsettings-desktop-schemas-3.18.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gsettings-desktop-schemas/gsettings-desktop-schemas-3.18.1.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gsettings-desktop-schemas/3.18/gsettings-desktop-schemas-3.18.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
glib-compile-schemas /usr/share/glib-2.0/schemas

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gsettings-desktop-schemas=>`date`" | sudo tee -a $INSTALLED_LIST

