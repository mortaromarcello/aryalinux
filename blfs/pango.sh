#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:pango:1.40.1

#REQ:fontconfig
#REQ:freetype2
#REQ:harfbuzz
#REQ:glib2
#REC:cairo
#REC:x7lib
#OPT:gobject-introspection
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/pango/1.40/pango-1.40.1.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pango/pango-1.40.1.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/pango/1.40/pango-1.40.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pango/pango-1.40.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pango/pango-1.40.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/pango/1.40/pango-1.40.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pango/pango-1.40.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pango/pango-1.40.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i "/seems to be moved/s/^/#/" ltmain.sh &&
./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "pango=>`date`" | sudo tee -a $INSTALLED_LIST

