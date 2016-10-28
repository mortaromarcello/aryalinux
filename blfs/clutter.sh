#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Clutter package contains anbr3ak open source software library used for creating fast, visually richbr3ak and animated graphical user interfaces.br3ak
#SECTION:x

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

wget -nc ftp://ftp.gnome.org/pub/gnome/sources/clutter/1.26/clutter-1.26.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/clutter/clutter-1.26.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/clutter/clutter-1.26.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/clutter/clutter-1.26.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/clutter/1.26/clutter-1.26.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/clutter/clutter-1.26.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/clutter/clutter-1.26.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/clutter/1.26/clutter-1.26.0.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr               \
            --sysconfdir=/etc           \
            --enable-egl-backend        \
            --enable-evdev-input        \
            --enable-wayland-backend    \
            --enable-wayland-compositor &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
