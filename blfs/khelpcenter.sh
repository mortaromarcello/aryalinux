#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:khelpcenter:16.04.2

#REQ:grantlee
#REQ:libxml2
#REQ:xapian
#REQ:kframeworks5


cd $SOURCE_DIR

URL=http://download.kde.org/stable/applications/16.04.2/src/khelpcenter-16.04.2.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/khelpcenter/khelpcenter-16.04.2.tar.xz || wget -nc http://download.kde.org/stable/applications/16.04.2/src/khelpcenter-16.04.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/khelpcenter/khelpcenter-16.04.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/khelpcenter/khelpcenter-16.04.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/khelpcenter/khelpcenter-16.04.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/khelpcenter/khelpcenter-16.04.2.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -DLIB_INSTALL_DIR=lib              \
      -DBUILD_TESTING=OFF                \
      -Wno-dev .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install  &&
mv -v $KF5_PREFIX/share/kde4/services/khelpcenter.desktop /usr/share/applications/ &&
rm -rv $KF5_PREFIX/share/kde4

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "khelpcenter=>`date`" | sudo tee -a $INSTALLED_LIST

