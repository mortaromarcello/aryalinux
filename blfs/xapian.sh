#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:xapian-core:1.2.22

#OPT:valgrind


cd $SOURCE_DIR

URL=http://oligarchy.co.uk/xapian/1.2.22/xapian-core-1.2.22.tar.xz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xapian/xapian-core-1.2.22.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xapian/xapian-core-1.2.22.tar.xz || wget -nc http://oligarchy.co.uk/xapian/1.2.22/xapian-core-1.2.22.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xapian/xapian-core-1.2.22.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xapian/xapian-core-1.2.22.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xapian/xapian-core-1.2.22.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xapian-core-1.2.22 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "xapian=>`date`" | sudo tee -a $INSTALLED_LIST

