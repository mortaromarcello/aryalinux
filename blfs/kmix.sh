#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:kmix:15.12.1

#REQ:kf5
#REC:alsa-lib
#OPT:libcanberra
#OPT:pulseaudio


cd $SOURCE_DIR

URL=http://download.kde.org/stable/applications/15.12.1/src/kmix-15.12.1.tar.xz

wget -nc ftp://ftp.kde.org/pub/kde/stable/15.12.1/src/kmix-15.12.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/kmix/kmix-15.12.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/kmix/kmix-15.12.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/kmix/kmix-15.12.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/kmix/kmix-15.12.1.tar.xz || wget -nc http://download.kde.org/stable/applications/15.12.1/src/kmix-15.12.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/kmix/kmix-15.12.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i "s:\${ECM_MODULE_PATH}:\${CMAKE_SOURCE_DIR}/cmake/modules &:g" CMakeLists.txt


mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -DLIB_INSTALL_DIR=lib              \
      -DBUILD_TESTING=OFF                \
      -DKMIX_KF5_BUILD=1                 \
      -DQT_PLUGIN_INSTALL_DIR=lib/qt5/plugins \
      -Wno-dev .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "kmix=>`date`" | sudo tee -a $INSTALLED_LIST

