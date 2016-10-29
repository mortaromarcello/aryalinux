#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The Wayland-Protocols packagebr3ak contains additional Wayland protocols that add functionalitybr3ak outside of protocols already in the Wayland core.br3ak"
SECTION="general"
VERSION=1.7
NAME="wayland-protocols"

#REQ:wayland


wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/wayland/wayland-protocols-1.7.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/wayland/wayland-protocols-1.7.tar.xz || wget -nc https://wayland.freedesktop.org/releases/wayland-protocols-1.7.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/wayland/wayland-protocols-1.7.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/wayland/wayland-protocols-1.7.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/wayland/wayland-protocols-1.7.tar.xz


URL=https://wayland.freedesktop.org/releases/wayland-protocols-1.7.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
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
