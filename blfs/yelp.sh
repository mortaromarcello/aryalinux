#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:yelp:3.22.0

#REQ:gsettings-desktop-schemas
#REQ:webkitgtk
#REQ:yelp-xsl
#REC:desktop-file-utils
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/yelp/3.22/yelp-3.22.0.tar.xz

wget -nc ftp://ftp.gnome.org/pub/gnome/sources/yelp/3.22/yelp-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/yelp/yelp-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/yelp/yelp-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/yelp/yelp-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/yelp/yelp-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/yelp/yelp-3.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/yelp/3.22/yelp-3.22.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
update-desktop-database

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "yelp=>`date`" | sudo tee -a $INSTALLED_LIST

