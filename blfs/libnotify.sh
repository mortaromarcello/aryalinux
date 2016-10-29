#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The libnotify library is used tobr3ak send desktop notifications to a notification daemon, as defined inbr3ak the Desktop Notifications spec. These notifications can be used tobr3ak inform the user about an event or display some form of informationbr3ak without getting in the user's way.br3ak"
SECTION="x"
VERSION=0.7.7
NAME="libnotify"

#REQ:gtk3
#REQ:notification-daemon
#OPT:gobject-introspection
#OPT:gtk-doc


wget -nc http://ftp.gnome.org/pub/gnome/sources/libnotify/0.7/libnotify-0.7.7.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libnotify/libnotify-0.7.7.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libnotify/libnotify-0.7.7.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libnotify/libnotify-0.7.7.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libnotify/0.7/libnotify-0.7.7.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libnotify/libnotify-0.7.7.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libnotify/libnotify-0.7.7.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/libnotify/0.7/libnotify-0.7.7.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
