#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak Gjs is a set of Javascriptbr3ak bindings for GNOME.br3ak"
SECTION="gnome"
VERSION=1.46.0
NAME="gjs"

#REQ:cairo
#REQ:gobject-introspection
#REQ:JS2
#REC:gtk3


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gjs/1.46/gjs-1.46.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gjs/gjs-1.46.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gjs/gjs-1.46.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gjs/gjs-1.46.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gjs/1.46/gjs-1.46.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gjs/gjs-1.46.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gjs/gjs-1.46.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gjs/1.46/gjs-1.46.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
