#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:clutter:1.24.2

#REQ:atk
#REQ:cogl
#REQ:json-glib
#REC:gobject-introspection
#REC:libgudev
#REC:libinput
#REC:libxkbcommon
#REC:wayland
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.acc.umu.se/pub/gnome/sources/clutter/1.22/clutter-1.22.4.tar.xz

wget -nc http://ftp.acc.umu.se/pub/gnome/sources/clutter/1.22/clutter-1.22.4.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr               \
            --sysconfdir=/etc           \
            --enable-egl-backend        \
            --enable-evdev-input        \
            --enable-wayland-backend    \
            --enable-wayland-compositor &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "clutter=>`date`" | sudo tee -a $INSTALLED_LIST

