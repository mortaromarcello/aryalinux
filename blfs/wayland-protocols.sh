#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:wayland-protocols:1.7

#REQ:wayland


cd $SOURCE_DIR

URL=https://wayland.freedesktop.org/releases/wayland-protocols-1.7.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/wayland/wayland-protocols-1.7.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/wayland/wayland-protocols-1.7.tar.xz || wget -nc https://wayland.freedesktop.org/releases/wayland-protocols-1.7.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/wayland/wayland-protocols-1.7.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/wayland/wayland-protocols-1.7.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/wayland/wayland-protocols-1.7.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

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
echo "wayland-protocols=>`date`" | sudo tee -a $INSTALLED_LIST

