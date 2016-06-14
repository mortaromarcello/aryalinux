#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:telepathy-glib:0.24.1

#REQ:dbus-glib
#REQ:libxslt
#REC:gobject-introspection
#REC:vala
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://telepathy.freedesktop.org/releases/telepathy-glib/telepathy-glib-0.24.1.tar.gz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/telepathy-glib/telepathy-glib-0.24.1.tar.gz || wget -nc http://telepathy.freedesktop.org/releases/telepathy-glib/telepathy-glib-0.24.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/telepathy-glib/telepathy-glib-0.24.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/telepathy-glib/telepathy-glib-0.24.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/telepathy-glib/telepathy-glib-0.24.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/telepathy-glib/telepathy-glib-0.24.1.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr \
            --enable-vala-bindings \
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
echo "telepathy-glib=>`date`" | sudo tee -a $INSTALLED_LIST

