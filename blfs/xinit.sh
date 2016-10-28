#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The xinit package contains abr3ak usable script to start the xserver.br3ak
#SECTION:x

#REQ:x7lib
#REQ:twm
#REQ:xclock
#REQ:xterm


#VER:xinit:1.3.4


NAME="xinit"

wget -nc ftp://ftp.x.org/pub/individual/app/xinit-1.3.4.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/Xorg/xinit-1.3.4.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/Xorg/xinit-1.3.4.tar.bz2 || wget -nc http://ftp.x.org/pub/individual/app/xinit-1.3.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/Xorg/xinit-1.3.4.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/Xorg/xinit-1.3.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/Xorg/xinit-1.3.4.tar.bz2


URL=http://ftp.x.org/pub/individual/app/xinit-1.3.4.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG --with-xinitdir=/etc/X11/app-defaults &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
ldconfig
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
