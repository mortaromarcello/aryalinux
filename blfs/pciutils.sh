#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:pciutils:3.5.1



cd $SOURCE_DIR

URL=https://ftp.kernel.org/pub/software/utils/pciutils/pciutils-3.5.1.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pciutils/pciutils-3.5.1.tar.xz || wget -nc ftp://ftp.kernel.org/pub/software/utils/pciutils/pciutils-3.5.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pciutils/pciutils-3.5.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pciutils/pciutils-3.5.1.tar.xz || wget -nc https://ftp.kernel.org/pub/software/utils/pciutils/pciutils-3.5.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pciutils/pciutils-3.5.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pciutils/pciutils-3.5.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

make PREFIX=/usr                \
     SHAREDIR=/usr/share/hwdata \
     SHARED=yes



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make PREFIX=/usr                \
     SHAREDIR=/usr/share/hwdata \
     SHARED=yes                 \
     install install-lib        &&
chmod -v 755 /usr/lib/libpci.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "pciutils=>`date`" | sudo tee -a $INSTALLED_LIST

