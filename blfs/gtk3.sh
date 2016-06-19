#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gtk+:3.18.6

#REQ:at-spi2-atk
#REQ:gdk-pixbuf
#REQ:pango
#REQ:wayland-protocols
#REC:hicolor-icon-theme
#REC:libxkbcommon
#REC:wayland
#OPT:gobject-introspection
#OPT:adwaita-icon-theme
#OPT:colord
#OPT:cups
#OPT:docbook-utils
#OPT:gtk-doc
#OPT:json-glib
#OPT:rest


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gtk+/3.18/gtk+-3.18.6.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gtk+/gtk+-3.18.6.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtk+/3.18/gtk+-3.18.6.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk+/3.18/gtk+-3.18.6.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk+/gtk+-3.18.6.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gtk+/gtk+-3.18.6.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk+/gtk+-3.18.6.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gtk+/gtk+-3.18.6.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr             \
            --sysconfdir=/etc         \
            --enable-broadway-backend \
            --enable-wayland-backend  \
            --enable-x11-backend      &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
glib-compile-schemas /usr/share/glib-2.0/schemas

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



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


mkdir -p ~/.config/gtk-3.0 &&
cat > ~/.config/gtk-3.0/settings.ini << "EOF"
[Settings]
gtk-theme-name = <em class="replaceable"><code>Adwaita</em>
gtk-icon-theme-name = <em class="replaceable"><code>Adwaita</em>
gtk-font-name = <em class="replaceable"><code>DejaVu Sans 12</em>
gtk-cursor-theme-size = <em class="replaceable"><code>18</em>
gtk-toolbar-style = <em class="replaceable"><code>GTK_TOOLBAR_BOTH_HORIZ</em>
gtk-xft-antialias = <em class="replaceable"><code>1</em>
gtk-xft-hinting = <em class="replaceable"><code>1</em>
gtk-xft-hintstyle = <em class="replaceable"><code>hintslight</em>
gtk-xft-rgba = <em class="replaceable"><code>rgb</em>
gtk-cursor-theme-names = <em class="replaceable"><code>Adwaita</em>
EOF



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/gtk-3.0/settings.ini << "EOF"
[Settings]
gtk-theme-name = <em class="replaceable"><code>Clearwaita</em>
gtk-fallback-icon-theme = <em class="replaceable"><code>elementary</em>
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gtk3=>`date`" | sudo tee -a $INSTALLED_LIST
