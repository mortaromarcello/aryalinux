#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:vte:0.28.2

#REQ:gtk2
#OPT:gobject-introspection
#OPT:gtk-doc
#OPT:python-modules#pygtk


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/vte/0.28/vte-0.28.2.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/vte/vte-0.28.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/vte/0.28/vte-0.28.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/vte/0.28/vte-0.28.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/vte/vte-0.28.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/vte/vte-0.28.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/vte/vte-0.28.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/vte/vte-0.28.2.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr \
            --libexecdir=/usr/lib/vte \
            --disable-static  &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "vte2=>`date`" | sudo tee -a $INSTALLED_LIST

