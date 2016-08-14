#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:cdparanoia-III-.src:10.2



cd $SOURCE_DIR

URL=http://downloads.xiph.org/releases/cdparanoia/cdparanoia-III-10.2.src.tgz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cdparanoia/cdparanoia-III-10.2.src.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cdparanoia/cdparanoia-III-10.2.src.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cdparanoia/cdparanoia-III-10.2.src.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cdparanoia/cdparanoia-III-10.2.src.tgz || wget -nc http://downloads.xiph.org/releases/cdparanoia/cdparanoia-III-10.2.src.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cdparanoia/cdparanoia-III-10.2.src.tgz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/cdparanoia-III-10.2-gcc_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/cdparanoia/cdparanoia-III-10.2-gcc_fixes-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../cdparanoia-III-10.2-gcc_fixes-1.patch &&
./configure --prefix=/usr --mandir=/usr/share/man &&
make -j1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chmod -v 755 /usr/lib/libcdda_*.so.0.10.2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "cdparanoia=>`date`" | sudo tee -a $INSTALLED_LIST

