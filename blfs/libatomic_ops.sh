#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libatomic_ops:7.4.2



cd $SOURCE_DIR

URL=http://www.ivmaisoft.com/_bin/atomic_ops/libatomic_ops-7.4.2.tar.gz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libatomic/libatomic_ops-7.4.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libatomic/libatomic_ops-7.4.2.tar.gz || wget -nc http://www.ivmaisoft.com/_bin/atomic_ops/libatomic_ops-7.4.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libatomic/libatomic_ops-7.4.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libatomic/libatomic_ops-7.4.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libatomic/libatomic_ops-7.4.2.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i 's#pkgdata#doc#' doc/Makefile.am &&
autoreconf -fi &&
./configure --prefix=/usr    \
            --enable-shared  \
            --disable-static \
            --docdir=/usr/share/doc/libatomic_ops-7.4.2 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mv -v   /usr/share/libatomic_ops/* \
        /usr/share/doc/libatomic_ops-7.4.2 &&
rm -vrf /usr/share/libatomic_ops

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libatomic_ops=>`date`" | sudo tee -a $INSTALLED_LIST

