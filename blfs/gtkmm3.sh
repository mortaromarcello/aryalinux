#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gtkmm:3.18.0

#REQ:atkmm
#REQ:gtk3
#REQ:pangomm


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gtkmm/3.18/gtkmm-3.18.0.tar.xz

wget -nc http://ftp.gnome.org/pub/gnome/sources/gtkmm/3.18/gtkmm-3.18.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtkmm/gtkmm-3.18.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gtkmm/gtkmm-3.18.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gtkmm/gtkmm-3.18.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtkmm/gtkmm-3.18.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gtkmm/gtkmm-3.18.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtkmm/3.18/gtkmm-3.18.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

sed -e '/^libdocdir =/ s/$(book_name)/gtkmm-3.18.0/' \
    -i docs/Makefile.in


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
echo "gtkmm3=>`date`" | sudo tee -a $INSTALLED_LIST

