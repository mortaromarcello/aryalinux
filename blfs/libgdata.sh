#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libgdata:0.16.1

#REQ:liboauth
#REQ:libsoup
#REQ:json-glib
#REQ:uhttpmock
#REC:gcr
#REC:gnome-online-accounts
#REC:gobject-introspection
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/libgdata/0.16/libgdata-0.16.1.tar.xz

wget -nc http://ftp.gnome.org/pub/gnome/sources/libgdata/0.16/libgdata-0.16.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libgdata/libgdata-0.16.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libgdata/libgdata-0.16.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libgdata/libgdata-0.16.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgdata/libgdata-0.16.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libgdata/0.16/libgdata-0.16.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgdata/libgdata-0.16.1.tar.xz

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
echo "libgdata=>`date`" | sudo tee -a $INSTALLED_LIST

