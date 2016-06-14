#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:amarok:2.8.0

#REQ:kdelibs
#REQ:mariadb
#REQ:taglib
#REC:add-pkgs#libkcompactdisk
#REC:add-pkgs#audiocd-kio
#REC:ffmpeg
#OPT:curl
#OPT:libxml2
#OPT:openssl
#OPT:qjson


cd $SOURCE_DIR

URL=http://download.kde.org/stable/amarok/2.8.0/src/amarok-2.8.0.tar.bz2

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/amarok/amarok-2.8.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/amarok/amarok-2.8.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/amarok/amarok-2.8.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/amarok/amarok-2.8.0.tar.bz2 || wget -nc ftp://ftp.kde.org/pub/kde/stable/amarok/2.8.0/src/amarok-2.8.0.tar.bz2 || wget -nc http://download.kde.org/stable/amarok/2.8.0/src/amarok-2.8.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/amarok/amarok-2.8.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

export KDE_PREFIX=/opt/kde


sed -i '/set.TAGLIB_MIN_VERSION/s/7/10/' CMakeLists.txt &&
mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -DKDE4_BUILD_TESTS=OFF             \
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
echo "amarok=>`date`" | sudo tee -a $INSTALLED_LIST

