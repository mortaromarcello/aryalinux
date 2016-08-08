#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:bridge-utils:1.5

#OPT:net-tools


cd $SOURCE_DIR

URL=http://sourceforge.net/projects/bridge/files/bridge/bridge-utils-1.5.tar.gz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/bridge-utils/bridge-utils-1.5.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/bridge-utils/bridge-utils-1.5.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/bridge-utils/bridge-utils-1.5.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/bridge-utils/bridge-utils-1.5.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/bridge-utils/bridge-utils-1.5.tar.gz || wget -nc http://sourceforge.net/projects/bridge/files/bridge/bridge-utils-1.5.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/downloads/bridge-utils/bridge-utils-1.5-linux_3.8_fix-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/bridge-utils-1.5-linux_3.8_fix-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../bridge-utils-1.5-linux_3.8_fix-1.patch &&
autoconf -o configure configure.in                      &&
./configure --prefix=/usr                               &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "bridge-utils=>`date`" | sudo tee -a $INSTALLED_LIST

