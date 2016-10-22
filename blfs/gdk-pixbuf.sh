#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gdk-pixbuf:2.36.0

#REQ:glib2
#REQ:libjpeg
#REQ:libpng
#REC:libtiff
#REC:x7lib
#OPT:gobject-introspection
#OPT:jasper
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.36/gdk-pixbuf-2.36.0.tar.xz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gdk-pixbuf/gdk-pixbuf-2.36.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gdk-pixbuf/gdk-pixbuf-2.36.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.36/gdk-pixbuf-2.36.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gdk-pixbuf/gdk-pixbuf-2.36.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gdk-pixbuf/gdk-pixbuf-2.36.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.36/gdk-pixbuf-2.36.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gdk-pixbuf/gdk-pixbuf-2.36.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i "/seems to be moved/s/^/#/" ltmain.sh &&
./configure --prefix=/usr --with-x11 &&
make "-j`nproc`"



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

sudo rm -rf $DIRECTORY
echo "gdk-pixbuf=>`date`" | sudo tee -a $INSTALLED_LIST

