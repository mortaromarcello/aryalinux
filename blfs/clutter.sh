#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Clutter package contains anbr3ak open source software library used for creating fast, visually richbr3ak and animated graphical user interfaces.br3ak
#SECTION:x

whoami > /tmp/currentuser

#REQ:atk
#REQ:cogl
#REQ:json-glib
#REC:gobject-introspection
#REC:gtk3
#REC:libgudev
#REC:x7driver
#REC:libxkbcommon
#REC:wayland
#OPT:gtk-doc


#VER:clutter:1.26.0


NAME="clutter"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.acc.umu.se/pub/gnome/sources/clutter/1.22/clutter-1.22.4.tar.xz


URL=http://ftp.acc.umu.se/pub/gnome/sources/clutter/1.22/clutter-1.22.4.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
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

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST