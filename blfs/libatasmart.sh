#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libatasmart package is a diskbr3ak reporting library. It only supports a subset of the ATA S.M.A.R.T.br3ak functionality.br3ak
#SECTION:general



#VER:libatasmart:0.19


NAME="libatasmart"

wget -nc http://0pointer.de/public/libatasmart-0.19.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libatasmart/libatasmart-0.19.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libatasmart/libatasmart-0.19.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libatasmart/libatasmart-0.19.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libatasmart/libatasmart-0.19.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libatasmart/libatasmart-0.19.tar.xz


URL=http://0pointer.de/public/libatasmart-0.19.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/libatasmart-0.19 install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
