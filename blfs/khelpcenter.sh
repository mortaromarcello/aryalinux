#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Khelpcenter is an application tobr3ak show KDE Applications' documentation.br3ak
#SECTION:kde

#REQ:grantlee
#REQ:krameworks5
#REQ:libxml2
#REQ:xapian


#VER:khelpcenter:16.08.0


NAME="khelpcenter"

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/khelpcenter/khelpcenter-16.08.0.tar.xz || wget -nc http://download.kde.org/stable/applications/16.08.0/src/khelpcenter-16.08.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/khelpcenter/khelpcenter-16.08.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/khelpcenter/khelpcenter-16.08.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/khelpcenter/khelpcenter-16.08.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/khelpcenter/khelpcenter-16.08.0.tar.xz


URL=http://download.kde.org/stable/applications/16.08.0/src/khelpcenter-16.08.0.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -DLIB_INSTALL_DIR=lib              \
      -DBUILD_TESTING=OFF                \
      -Wno-dev .. &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install  &&

mv -v $KF5_PREFIX/share/kde4/services/khelpcenter.desktop /usr/share/applications/ &&
rm -rv $KF5_PREFIX/share/kde4
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
