#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The xcb-util-renderutil packagebr3ak provides additional extensions to the XCB library.br3ak
#SECTION:x

#REQ:libxcb


#VER:xcb-util-renderutil:0.3.9


NAME="xcb-util-renderutil"

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xcb-util-renderutil/xcb-util-renderutil-0.3.9.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xcb-util-renderutil/xcb-util-renderutil-0.3.9.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xcb-util-renderutil/xcb-util-renderutil-0.3.9.tar.bz2 || wget -nc http://xcb.freedesktop.org/dist/xcb-util-renderutil-0.3.9.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xcb-util-renderutil/xcb-util-renderutil-0.3.9.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xcb-util-renderutil/xcb-util-renderutil-0.3.9.tar.bz2


URL=http://xcb.freedesktop.org/dist/xcb-util-renderutil-0.3.9.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG &&
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
