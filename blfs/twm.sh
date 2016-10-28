#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The twm package contains a verybr3ak minimal window manager.br3ak
#SECTION:x

#REQ:xorg-server


#VER:twm:1.0.9


NAME="twm"

wget -nc http://ftp.x.org/pub/individual/app/twm-1.0.9.tar.bz2 || wget -nc ftp://ftp.x.org/pub/individual/app/twm-1.0.9.tar.bz2


URL=http://ftp.x.org/pub/individual/app/twm-1.0.9.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

sed -i -e '/^rcdir =/s,^\(rcdir = \).*,\1/etc/X11/app-defaults,' src/Makefile.in &&
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
