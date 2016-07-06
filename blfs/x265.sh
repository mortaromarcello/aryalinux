#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:x:265_1.9

#REQ:cmake
#REC:yasm


cd $SOURCE_DIR

URL=https://bitbucket.org/multicoreware/x265/downloads/x265_1.9.tar.gz

wget -nc http://www.linuxfromscratch.org/patches/downloads/x265/x265-1.9-enable_static-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/x265-1.9-enable_static-1.patch
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/x265/x265_1.9.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/x265/x265_1.9.tar.gz || wget -nc https://bitbucket.org/multicoreware/x265/downloads/x265_1.9.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/x265/x265_1.9.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/x265/x265_1.9.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/x265/x265_1.9.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../x265-1.9-enable_static-1.patch &&
mkdir bld &&
cd bld &&
cmake -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DCMAKE_INSTALL_PREFIX=/usr \
      -DENABLE_STATIC=OFF         \
      ../source                   &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "x265=>`date`" | sudo tee -a $INSTALLED_LIST

