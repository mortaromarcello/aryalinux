#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GtkSourceView package containsbr3ak libraries used for extending the GTK+ text functions to include syntaxbr3ak highlighting.br3ak
#SECTION:x

#REQ:gtk3
#REC:gobject-introspection
#OPT:vala
#OPT:valgrind
#OPT:gtk-doc
#OPT:itstool
#OPT:fop


#VER:gtksourceview:3.22.0


NAME="gtksourceview"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtksourceview/gtksourceview-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gtksourceview/gtksourceview-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gtksourceview/gtksourceview-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gtksourceview/gtksourceview-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtksourceview/gtksourceview-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtksourceview/3.22/gtksourceview-3.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gtksourceview/3.22/gtksourceview-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gtksourceview/3.22/gtksourceview-3.22.0.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
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
