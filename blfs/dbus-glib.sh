#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The D-Bus GLib package containsbr3ak GLib interfaces to thebr3ak D-Bus API.br3ak
#SECTION:general

#REQ:dbus
#REQ:glib2
#OPT:gtk-doc


#VER:dbus-glib:0.108


NAME="dbus-glib"

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/dbus-glib/dbus-glib-0.108.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/dbus-glib/dbus-glib-0.108.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/dbus-glib/dbus-glib-0.108.tar.gz || wget -nc http://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.108.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/dbus-glib/dbus-glib-0.108.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/dbus-glib/dbus-glib-0.108.tar.gz


URL=http://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.108.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static &&
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
