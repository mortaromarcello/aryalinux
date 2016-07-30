#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:grilo:0.3.1

#REQ:glib2
#REQ:libxml2
#REC:gobject-introspection
#REC:gtk3
#REC:libsoup
#REC:totem-pl-parser
#REC:vala
#OPT:avahi
#OPT:docbook-utils
#OPT:liboauth
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/grilo/0.3/grilo-0.3.1.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/grilo/grilo-0.3.1.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/grilo/0.3/grilo-0.3.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/grilo/grilo-0.3.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/grilo/0.3/grilo-0.3.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/grilo/grilo-0.3.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/grilo/grilo-0.3.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/grilo/grilo-0.3.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --libdir=/usr/lib \
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
echo "grilo=>`date`" | sudo tee -a $INSTALLED_LIST

