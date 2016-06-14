#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:openjpeg:2.1.0

#REQ:cmake
#OPT:lcms2
#OPT:libpng
#OPT:libtiff
#OPT:doxygen


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/openjpeg.mirror/openjpeg-2.1.0.tar.gz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjpeg/openjpeg-2.1.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openjpeg/openjpeg-2.1.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openjpeg/openjpeg-2.1.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openjpeg/openjpeg-2.1.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjpeg/openjpeg-2.1.0.tar.gz || wget -nc http://downloads.sourceforge.net/openjpeg.mirror/openjpeg-2.1.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

mkdir -v build &&
cd       build &&
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
pushd ../doc &&
for man in man/man?/* ; do
    install -v -D -m 644 $man /usr/share/$man
done         &&
popd

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "openjpeg2=>`date`" | sudo tee -a $INSTALLED_LIST

