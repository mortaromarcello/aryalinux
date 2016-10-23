#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gnome-autoar:0.1.1

#REQ:libarchive
#REQ:gtk3
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gnome-autoar/0.1/gnome-autoar-0.1.1.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-autoar/gnome-autoar-0.1.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-autoar/0.1/gnome-autoar-0.1.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-autoar/gnome-autoar-0.1.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-autoar/gnome-autoar-0.1.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-autoar/gnome-autoar-0.1.1.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-autoar/0.1/gnome-autoar-0.1.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-autoar/gnome-autoar-0.1.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gnome-autoar=>`date`" | sudo tee -a $INSTALLED_LIST
