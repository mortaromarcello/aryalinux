#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:glib-networking:2.46.1

#REQ:glib2
#REQ:gnutls
#REQ:gsettings-desktop-schemas
#REC:cacerts
#REC:p11-kit


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/glib-networking/2.46/glib-networking-2.46.1.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/glib-networking/glib-networking-2.46.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/glib-networking/glib-networking-2.46.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/glib-networking/2.46/glib-networking-2.46.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/glib-networking/glib-networking-2.46.1.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/glib-networking/2.46/glib-networking-2.46.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/glib-networking/glib-networking-2.46.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/glib-networking/glib-networking-2.46.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr                                 \
            --with-ca-certificates=/etc/ssl/ca-bundle.crt \
            --disable-static                              &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "glib-networking=>`date`" | sudo tee -a $INSTALLED_LIST

