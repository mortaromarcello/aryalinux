#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libsoup is a HTTPbr3ak client/server library for GNOME.br3ak It uses GObject and the GLib main loop to integrate withbr3ak GNOME applications and it also hasbr3ak an asynchronous API for use in threaded applications.br3ak
#SECTION:basicnet

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


#VER:libsoup:2.56.0


NAME="libsoup"

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libsoup/libsoup-2.56.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libsoup/libsoup-2.56.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libsoup/libsoup-2.56.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libsoup/2.56/libsoup-2.56.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/libsoup/2.56/libsoup-2.56.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libsoup/libsoup-2.56.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libsoup/libsoup-2.56.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/libsoup/2.56/libsoup-2.56.0.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

sed -i "/seems to be moved/s/^/#/" build-aux/ltmain.sh &&
./configure --prefix=/usr --disable-static &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
