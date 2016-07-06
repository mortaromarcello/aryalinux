#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:tiff:4.0.6

#OPT:freeglut
#OPT:libjpeg


cd $SOURCE_DIR

URL=http://download.osgeo.org/libtiff/tiff-4.0.6.tar.gz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/tiff/tiff-4.0.6.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/tiff/tiff-4.0.6.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/tiff/tiff-4.0.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/tiff/tiff-4.0.6.tar.gz || wget -nc ftp://ftp.remotesensing.org/libtiff/tiff-4.0.6.tar.gz || wget -nc http://download.osgeo.org/libtiff/tiff-4.0.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/tiff/tiff-4.0.6.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

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
echo "libtiff=>`date`" | sudo tee -a $INSTALLED_LIST

