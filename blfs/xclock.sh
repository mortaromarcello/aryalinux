#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The xclock package contains abr3ak simple clock application which is used in the default xinitbr3ak configuration.br3ak
#SECTION:x

#REQ:x7lib


#VER:xclock:1.0.7


NAME="xclock"

wget -nc http://ftp.x.org/pub/individual/app/xclock-1.0.7.tar.bz2 || wget -nc ftp://ftp.x.org/pub/individual/app/xclock-1.0.7.tar.bz2


URL=http://ftp.x.org/pub/individual/app/xclock-1.0.7.tar.bz2
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
