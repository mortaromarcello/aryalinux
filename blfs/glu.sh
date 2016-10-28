#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak This package provides the Mesa OpenGL Utility library.br3ak
#SECTION:x

#REQ:mesa


#VER:glu:9.0.0


NAME="glu"

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/MesaLib/glu-9.0.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/MesaLib/glu-9.0.0.tar.bz2 || wget -nc ftp://ftp.freedesktop.org/pub/mesa/glu/glu-9.0.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/MesaLib/glu-9.0.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/MesaLib/glu-9.0.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/MesaLib/glu-9.0.0.tar.bz2


URL=ftp://ftp.freedesktop.org/pub/mesa/glu/glu-9.0.0.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=$XORG_PREFIX --disable-static &&
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
