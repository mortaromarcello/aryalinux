#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gtkhtml:4.8.5

#REQ:enchant
#REQ:gsettings-desktop-schemas
#REQ:gtk3
#REQ:iso-codes
#REC:libsoup


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gtkhtml/4.8/gtkhtml-4.8.5.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gtkhtml/gtkhtml-4.8.5.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtkhtml/gtkhtml-4.8.5.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gtkhtml/gtkhtml-4.8.5.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gtkhtml/gtkhtml-4.8.5.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtkhtml/gtkhtml-4.8.5.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gtkhtml/4.8/gtkhtml-4.8.5.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gtkhtml=>`date`" | sudo tee -a $INSTALLED_LIST

