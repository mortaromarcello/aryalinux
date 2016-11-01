#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The GLib Networking packagebr3ak contains Network related gio modules for GLib.br3ak"
SECTION="basicnet"
VERSION=2.50.0
NAME="glib-networking"

#REQ:glib2
#REQ:gnutls
#REQ:gsettings-desktop-schemas
#REC:cacerts
#REC:p11-kit


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/glib-networking/2.50/glib-networking-2.50.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/glib-networking/glib-networking-2.50.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/glib-networking/glib-networking-2.50.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/glib-networking/glib-networking-2.50.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/glib-networking/2.50/glib-networking-2.50.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/glib-networking/glib-networking-2.50.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/glib-networking/2.50/glib-networking-2.50.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/glib-networking/glib-networking-2.50.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

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




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
