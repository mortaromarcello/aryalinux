#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The XKeyboardConfig packagebr3ak contains the keyboard configuration database for the X Windowbr3ak System.br3ak
#SECTION:x

#REQ:x7lib


#VER:xkeyboard-config:2.19


NAME="xkeyboard-config"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xkeyboard-config/xkeyboard-config-2.19.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xkeyboard-config/xkeyboard-config-2.19.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xkeyboard-config/xkeyboard-config-2.19.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xkeyboard-config/xkeyboard-config-2.19.tar.bz2 || wget -nc ftp://ftp.x.org/pub/individual/data/xkeyboard-config/xkeyboard-config-2.19.tar.bz2 || wget -nc http://xorg.freedesktop.org/archive/individual/data/xkeyboard-config/xkeyboard-config-2.19.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xkeyboard-config/xkeyboard-config-2.19.tar.bz2


URL=http://xorg.freedesktop.org/archive/individual/data/xkeyboard-config/xkeyboard-config-2.19.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG --with-xkb-rules-symlink=xorg &&
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
