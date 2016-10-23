#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GLib Networking packagebr3ak contains Network related gio modules for GLib.br3ak
#SECTION:basicnet

whoami > /tmp/currentuser

#REQ:glib2
#REQ:gnutls
#REQ:gsettings-desktop-schemas
#REC:cacerts
#REC:p11-kit


#VER:glib-networking:2.50.0


NAME="glib-networking"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/glib-networking/glib-networking-2.50.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/glib-networking/glib-networking-2.50.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/glib-networking/glib-networking-2.50.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/glib-networking/2.50/glib-networking-2.50.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/glib-networking/glib-networking-2.50.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/glib-networking/2.50/glib-networking-2.50.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/glib-networking/glib-networking-2.50.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/glib-networking/2.50/glib-networking-2.50.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr                                 \
            --with-ca-certificates=/etc/ssl/ca-bundle.crt \
            --disable-static                              &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
