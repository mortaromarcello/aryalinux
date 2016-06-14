#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:openjpeg:1.5.2

#OPT:lcms2
#OPT:libpng
#OPT:libtiff
#OPT:doxygen


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/openjpeg.mirror/openjpeg-1.5.2.tar.gz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjpeg/openjpeg-1.5.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjpeg/openjpeg-1.5.2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openjpeg/openjpeg-1.5.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openjpeg/openjpeg-1.5.2.tar.gz || wget -nc http://downloads.sourceforge.net/openjpeg.mirror/openjpeg-1.5.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openjpeg/openjpeg-1.5.2.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

autoreconf -f -i &&
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
echo "openjpeg=>`date`" | sudo tee -a $INSTALLED_LIST

