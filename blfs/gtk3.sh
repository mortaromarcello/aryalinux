#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#VER:gtk+:3.20.6

#REQ:at-spi2-atk
#REQ:gdk-pixbuf
#REQ:libepoxy
#REQ:pango
#REQ:wayland-protocols
#REC:hicolor-icon-theme
#REC:adwaita-icon-theme
#REC:gobject-introspection
#OPT:colord
#OPT:cups
#OPT:docbook-utils
#OPT:gtk-doc
#OPT:json-glib
#OPT:libxkbcommon
#OPT:rest
#OPT:wayland
#OPT:wayland-protocols


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gtk+/3.22/gtk+-3.22.2.tar.xz

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i "/seems to be moved/s/^/#/" build-aux/ltmain.sh &&
./configure --prefix=/usr             \
            --sysconfdir=/etc         \
            --enable-broadway-backend \
            --enable-x11-backend      \
            --disable-wayland-backend &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gtk-query-immodules-3.0 --update-cache

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


mkdir -vp ~/.config/gtk-3.0
cat > ~/.config/gtk-3.0/settings.ini << "EOF"
[Settings]
gtk-theme-name = Adwaita
gtk-icon-theme-name = oxygen
gtk-font-name = DejaVu Sans 12
gtk-cursor-theme-size = 18
gtk-toolbar-style = GTK_TOOLBAR_BOTH_HORIZ
gtk-xft-antialias = 1
gtk-xft-hinting = 1
gtk-xft-hintstyle = hintslight
gtk-xft-rgba = rgb
gtk-cursor-theme-name = Adwaita
EOF


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gtk3=>`date`" | sudo tee -a $INSTALLED_LIST

