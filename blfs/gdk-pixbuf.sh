#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Gdk Pixbuf is a toolkit forbr3ak image loading and pixel buffer manipulation. It is used bybr3ak GTK+ 2 and GTK+ 3 to load and manipulate images. In thebr3ak past it was distributed as part of GTK+br3ak 2 but it was split off into a separate package inbr3ak preparation for the change to GTK+br3ak 3.br3ak
#SECTION:x

whoami > /tmp/currentuser

#REQ:glib2
#REQ:libjpeg
#REQ:libpng
#REC:libtiff
#REC:x7lib
#OPT:gobject-introspection
#OPT:jasper
#OPT:gtk-doc


#VER:gdk-pixbuf:2.36.0


NAME="gdk-pixbuf"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gdk-pixbuf/gdk-pixbuf-2.36.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gdk-pixbuf/gdk-pixbuf-2.36.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.36/gdk-pixbuf-2.36.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gdk-pixbuf/gdk-pixbuf-2.36.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gdk-pixbuf/gdk-pixbuf-2.36.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.36/gdk-pixbuf-2.36.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gdk-pixbuf/gdk-pixbuf-2.36.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.36/gdk-pixbuf-2.36.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i "/seems to be moved/s/^/#/" ltmain.sh &&
./configure --prefix=/usr --with-x11 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gdk-pixbuf-query-loaders --update-cache

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
