#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libsoup is a HTTPbr3ak client/server library for GNOME.br3ak It uses GObject and the GLib main loop to integrate withbr3ak GNOME applications and it also hasbr3ak an asynchronous API for use in threaded applications.br3ak"
SECTION="basicnet"
VERSION=2.56.0
NAME="libsoup"

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

URL=http://ftp.gnome.org/pub/gnome/sources/libsoup/2.56/libsoup-2.56.0.tar.xz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libsoup/libsoup-2.56.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libsoup/libsoup-2.56.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libsoup/libsoup-2.56.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libsoup/2.56/libsoup-2.56.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/libsoup/2.56/libsoup-2.56.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libsoup/libsoup-2.56.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libsoup/libsoup-2.56.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

sed -i "/seems to be moved/s/^/#/" build-aux/ltmain.sh &&
./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
