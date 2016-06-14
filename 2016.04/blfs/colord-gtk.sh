#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:colord-gtk:0.1.26

#REQ:colord
#REQ:gtk3
#REC:gobject-introspection
#REC:vala
#OPT:docbook-utils
#OPT:gtk2
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://www.freedesktop.org/software/colord/releases/colord-gtk-0.1.26.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/colord-gtk/colord-gtk-0.1.26.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/colord-gtk/colord-gtk-0.1.26.tar.xz || wget -nc http://www.freedesktop.org/software/colord/releases/colord-gtk-0.1.26.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/colord-gtk/colord-gtk-0.1.26.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/colord-gtk/colord-gtk-0.1.26.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/colord-gtk/colord-gtk-0.1.26.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr    \
            --enable-vala    \
            --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "colord-gtk=>`date`" | sudo tee -a $INSTALLED_LIST

