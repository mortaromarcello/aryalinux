#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libsoup:2.52.2

#REQ:glib-networking
#REQ:libxml2
#REQ:sqlite
#REC:gobject-introspection
#REC:vala
#OPT:apache
#OPT:curl
#OPT:gtk-doc
#OPT:php
#OPT:samba


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/libsoup/2.52/libsoup-2.52.2.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libsoup/libsoup-2.52.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libsoup/2.52/libsoup-2.52.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libsoup/libsoup-2.52.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libsoup/libsoup-2.52.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libsoup/libsoup-2.52.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libsoup/libsoup-2.52.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/libsoup/2.52/libsoup-2.52.2.tar.xz

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
echo "libsoup=>`date`" | sudo tee -a $INSTALLED_LIST

