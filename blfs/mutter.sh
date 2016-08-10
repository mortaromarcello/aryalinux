#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:mutter:3.20.3

#REQ:clutter
#REQ:gnome-desktop
#REQ:libxkbcommon
#REQ:upower
#REQ:zenity
#REC:gobject-introspection
#REC:libcanberra
#REC:startup-notification
#REC:x7driver
#REC:wayland
#REC:wayland-protocols
#REC:xorg-server
#REC:cogl
#REC:clutter
#REC:gtk3


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/mutter/3.20/mutter-3.20.3.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mutter/mutter-3.20.3.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/mutter/3.20/mutter-3.20.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mutter/mutter-3.20.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mutter/mutter-3.20.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mutter/mutter-3.20.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mutter/mutter-3.20.3.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/mutter/3.20/mutter-3.20.3.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "mutter=>`date`" | sudo tee -a $INSTALLED_LIST

