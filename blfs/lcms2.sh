#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:lcms2:2.8

#OPT:libjpeg
#OPT:libtiff


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/lcms/lcms2-2.8.tar.gz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lcms2/lcms2-2.8.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lcms2/lcms2-2.8.tar.gz || wget -nc http://downloads.sourceforge.net/lcms/lcms2-2.8.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lcms2/lcms2-2.8.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lcms2/lcms2-2.8.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lcms2/lcms2-2.8.tar.gz

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
echo "lcms2=>`date`" | sudo tee -a $INSTALLED_LIST

