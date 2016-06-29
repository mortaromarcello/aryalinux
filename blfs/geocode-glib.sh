#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:geocode-glib:3.18.1

#REQ:json-glib
#REQ:libsoup
#REC:gobject-introspection
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/geocode-glib/3.18/geocode-glib-3.18.1.tar.xz

wget -nc http://www.linuxfromscratch.org/patches/downloads/geocode-glib/geocode-glib-3.18.1-fix_icon_installation-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/geocode-glib-3.18.1-fix_icon_installation-1.patch
wget -nc http://ftp.gnome.org/pub/gnome/sources/geocode-glib/3.18/geocode-glib-3.18.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/geocode-glib/3.18/geocode-glib-3.18.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/geocode-glib/geocode-glib-3.18.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/geocode-glib/geocode-glib-3.18.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/geocode-glib/geocode-glib-3.18.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/geocode-glib/geocode-glib-3.18.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/geocode-glib/geocode-glib-3.18.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../geocode-glib-3.18.1-fix_icon_installation-1.patch


./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "geocode-glib=>`date`" | sudo tee -a $INSTALLED_LIST

