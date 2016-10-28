#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Xapian is an open source search engine library.br3ak
#SECTION:general

#OPT:valgrind


#VER:xapian-core:1.4.0


NAME="xapian"

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xapian/xapian-core-1.4.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xapian/xapian-core-1.4.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xapian/xapian-core-1.4.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xapian/xapian-core-1.4.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xapian/xapian-core-1.4.0.tar.xz || wget -nc http://oligarchy.co.uk/xapian/1.4.0/xapian-core-1.4.0.tar.xz


URL=http://oligarchy.co.uk/xapian/1.4.0/xapian-core-1.4.0.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xapian-core-1.4.0 &&
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
