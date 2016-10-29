#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The GTK+ 2 package containsbr3ak libraries used for creating graphical user interfaces forbr3ak applications.br3ak"
SECTION="x"
VERSION=2.24.31
NAME="gtk2"

#REQ:atk
#REQ:gdk-pixbuf
#REQ:pango
#REC:hicolor-icon-theme
#OPT:cups
#OPT:docbook-utils
#OPT:gobject-introspection
#OPT:gtk-doc


wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gtk+/gtk+-2.24.31.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk+/gtk+-2.24.31.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.31.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk+/gtk+-2.24.31.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gtk+/gtk+-2.24.31.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gtk+/gtk+-2.24.31.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.31.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.31.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -e 's#l \(gtk-.*\).sgml#& -o \1#' \
    -i docs/{faq,tutorial}/Makefile.in      &&
sed -i "/seems to be moved/s/^/#/" ltmain.sh &&
./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gtk-query-immodules-2.0 --update-cache

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cat > ~/.gtkrc-2.0 << "EOF"
include "/usr/share/themes/<em class="replaceable"><code>Glider</em>/gtk-2.0/gtkrc"
gtk-icon-theme-name = "<em class="replaceable"><code>hicolor</em>"
EOF



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/gtk-2.0/gtkrc << "EOF"
include "/usr/share/themes/<em class="replaceable"><code>Clearlooks</em>/gtk-2.0/gtkrc"
gtk-icon-theme-name = "<em class="replaceable"><code>elementary</em>"
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
