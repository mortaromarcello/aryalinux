#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gnome-maps:3.14.2

#REQ:clutter-gtk
#REQ:geoclue2
#REQ:geocode-glib
#REQ:gjs
#REQ:libchamplain


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gnome-maps/3.14/gnome-maps-3.14.2.tar.xz

wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-maps/3.14/gnome-maps-3.14.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-maps/3.14/gnome-maps-3.14.2.tar.xz

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
echo "gnome-maps=>`date`" | sudo tee -a $INSTALLED_LIST

