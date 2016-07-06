#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gnome-bluetooth:3.18.2

#REQ:gtk3
#REQ:itstool
#REQ:libcanberra
#REC:gobject-introspection
#OPT:gtk-doc
#OPT:bluez
#OPT:systemd


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gnome-bluetooth/3.18/gnome-bluetooth-3.18.2.tar.xz

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-bluetooth/3.18/gnome-bluetooth-3.18.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-bluetooth/gnome-bluetooth-3.18.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-bluetooth/gnome-bluetooth-3.18.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-bluetooth/gnome-bluetooth-3.18.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-bluetooth/gnome-bluetooth-3.18.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-bluetooth/gnome-bluetooth-3.18.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-bluetooth/3.18/gnome-bluetooth-3.18.2.tar.xz

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
echo "gnome-bluetooth=>`date`" | sudo tee -a $INSTALLED_LIST

