#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gnome-menus:3.13.3

#REQ:glib2
#REC:gobject-introspection


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gnome-menus/3.13/gnome-menus-3.13.3.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-menus/gnome-menus-3.13.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-menus/gnome-menus-3.13.3.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-menus/3.13/gnome-menus-3.13.3.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-menus/3.13/gnome-menus-3.13.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-menus/gnome-menus-3.13.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-menus/gnome-menus-3.13.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-menus/gnome-menus-3.13.3.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr \
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
echo "gnome-menus=>`date`" | sudo tee -a $INSTALLED_LIST

