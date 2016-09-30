#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:net-tools-CVS_:20101030



cd $SOURCE_DIR

URL=http://anduin.linuxfromscratch.org/BLFS/net-tools/net-tools-CVS_20101030.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/net-tools/net-tools-CVS_20101030.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/net-tools/net-tools-CVS_20101030.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/net-tools/net-tools-CVS_20101030.tar.gz || wget -nc ftp://anduin.linuxfromscratch.org/BLFS/net-tools/net-tools-CVS_20101030.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/net-tools/net-tools-CVS_20101030.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/net-tools/net-tools-CVS_20101030.tar.gz || wget -nc http://anduin.linuxfromscratch.org/BLFS/net-tools/net-tools-CVS_20101030.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/downloads/net-tools/net-tools-CVS_20101030-remove_dups-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/7.10/net-tools-CVS_20101030-remove_dups-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../net-tools-CVS_20101030-remove_dups-1.patch &&
yes "" | make config &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make update

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "net-tools=>`date`" | sudo tee -a $INSTALLED_LIST

