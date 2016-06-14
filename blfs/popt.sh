#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:popt:1.16



cd $SOURCE_DIR

URL=http://rpm5.org/files/popt/popt-1.16.tar.gz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/popt/popt-1.16.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/popt/popt-1.16.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/popt/popt-1.16.tar.gz || wget -nc ftp://anduin.linuxfromscratch.org/BLFS/popt/popt-1.16.tar.gz || wget -nc http://rpm5.org/files/popt/popt-1.16.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/popt/popt-1.16.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/popt/popt-1.16.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "popt=>`date`" | sudo tee -a $INSTALLED_LIST

