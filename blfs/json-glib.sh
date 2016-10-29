#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The JSON GLib package is a librarybr3ak providing serialization and deserialization support for thebr3ak JavaScript Object Notation (JSON) format described by RFC 4627.br3ak"
SECTION="general"
VERSION=1.2.2
NAME="json-glib"

#REQ:glib2
#OPT:gobject-introspection
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/json-glib/1.2/json-glib-1.2.2.tar.xz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/json-glib/json-glib-1.2.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/json-glib/json-glib-1.2.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/json-glib/1.2/json-glib-1.2.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/json-glib/json-glib-1.2.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/json-glib/json-glib-1.2.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/json-glib/1.2/json-glib-1.2.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/json-glib/json-glib-1.2.2.tar.xz

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
