#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The util-macros package containsbr3ak the m4 macros used by all of thebr3ak Xorg packages.br3ak
#SECTION:x

#REQ:xorg7#xorg-env


#VER:util-macros:1.19.0


NAME="util-macros"

wget -nc ftp://ftp.x.org/pub/individual/util/util-macros-1.19.0.tar.bz2 || wget -nc http://ftp.x.org/pub/individual/util/util-macros-1.19.0.tar.bz2


URL=http://ftp.x.org/pub/individual/util/util-macros-1.19.0.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
