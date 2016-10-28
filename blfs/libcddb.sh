#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libcddb is a library thatbr3ak implements the different protocols (CDDBP, HTTP, SMTP) to accessbr3ak data on a CDDB server.br3ak
#SECTION:multimedia



#VER:libcddb:1.3.2


NAME="libcddb"

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libcddb/libcddb-1.3.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcddb/libcddb-1.3.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libcddb/libcddb-1.3.2.tar.bz2 || wget -nc https://sourceforge.net/projects/libcddb/files/libcddb/1.3.2/libcddb-1.3.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcddb/libcddb-1.3.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libcddb/libcddb-1.3.2.tar.bz2


URL=https://sourceforge.net/projects/libcddb/files/libcddb/1.3.2/libcddb-1.3.2.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
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
