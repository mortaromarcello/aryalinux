#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The Clutter Gtk package is abr3ak library providing facilities to integrate Clutter into GTK+ applications.br3ak"
SECTION="x"
VERSION=1.8.2
NAME="clutter-gtk"

#REQ:clutter
#REQ:gtk3
#REC:gobject-introspection
#OPT:gtk-doc


wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/clutter/clutter-gtk-1.8.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/clutter/clutter-gtk-1.8.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/clutter-gtk/1.8/clutter-gtk-1.8.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/clutter/clutter-gtk-1.8.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/clutter/clutter-gtk-1.8.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/clutter/clutter-gtk-1.8.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/clutter-gtk/1.8/clutter-gtk-1.8.2.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/clutter-gtk/1.8/clutter-gtk-1.8.2.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
