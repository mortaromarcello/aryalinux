#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The xcb-util-keysyms packagebr3ak contains a library for handling standard X key constants andbr3ak conversion to/from keycodes.br3ak"
SECTION="x"
VERSION=0.4.0
NAME="xcb-util-keysyms"

#REQ:libxcb


wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xcb-util/xcb-util-keysyms-0.4.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xcb-util/xcb-util-keysyms-0.4.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xcb-util/xcb-util-keysyms-0.4.0.tar.bz2 || wget -nc http://xcb.freedesktop.org/dist/xcb-util-keysyms-0.4.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xcb-util/xcb-util-keysyms-0.4.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xcb-util/xcb-util-keysyms-0.4.0.tar.bz2


URL=http://xcb.freedesktop.org/dist/xcb-util-keysyms-0.4.0.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

./configure $XORG_CONFIG &&
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
