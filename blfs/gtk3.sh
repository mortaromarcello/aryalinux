#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The GTK+ 3 package containsbr3ak libraries used for creating graphical user interfaces forbr3ak applications.br3ak"
SECTION="x"
VERSION=3.22.1
NAME="gtk3"

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


wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gtk+/gtk+-3.22.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtk+/3.22/gtk+-3.22.1.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk+/3.22/gtk+-3.22.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gtk+/gtk+-3.22.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk+/gtk+-3.22.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk+/gtk+-3.22.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gtk+/gtk+-3.22.1.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gtk+/3.22/gtk+-3.22.1.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i "/seems to be moved/s/^/#/" build-aux/ltmain.sh &&
./configure --prefix=/usr             \
            --sysconfdir=/etc         \
            --enable-broadway-backend \
            --enable-x11-backend      \
            --disable-wayland-backend &&
make "-j`nproc`" || make



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
gtk-theme-name = <em class="replaceable"><code>Adwaita</em>
gtk-icon-theme-name = <em class="replaceable"><code>oxygen</em>
gtk-font-name = <em class="replaceable"><code>DejaVu Sans 12</em>
gtk-cursor-theme-size = <em class="replaceable"><code>18</em>
gtk-toolbar-style = <em class="replaceable"><code>GTK_TOOLBAR_BOTH_HORIZ</em>
gtk-xft-antialias = <em class="replaceable"><code>1</em>
gtk-xft-hinting = <em class="replaceable"><code>1</em>
gtk-xft-hintstyle = <em class="replaceable"><code>hintslight</em>
gtk-xft-rgba = <em class="replaceable"><code>rgb</em>
gtk-cursor-theme-name = <em class="replaceable"><code>Adwaita</em>
EOF



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
