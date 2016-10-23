#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The JSON GLib package is a librarybr3ak providing serialization and deserialization support for thebr3ak JavaScript Object Notation (JSON) format described by RFC 4627.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:glib2
#OPT:gobject-introspection
#OPT:gtk-doc


#VER:json-glib:1.2.2


NAME="json-glib"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/json-glib/json-glib-1.2.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/json-glib/json-glib-1.2.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/json-glib/1.2/json-glib-1.2.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/json-glib/json-glib-1.2.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/json-glib/json-glib-1.2.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/json-glib/1.2/json-glib-1.2.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/json-glib/json-glib-1.2.2.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/json-glib/1.2/json-glib-1.2.2.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

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

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST