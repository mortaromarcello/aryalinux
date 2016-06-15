#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:kdelibs:4.14.9

#REQ:attica
#REQ:automoc4
#REQ:docbook
#REQ:docbook-xsl
#REQ:giflib
#REQ:general_libdbusmenu-qt
#REQ:libjpeg
#REQ:libpng
#REQ:phonon
#REQ:shared-mime-info
#REQ:strigi
#REC:openssl
#REC:polkit-qt
#REC:qca
#REC:udisks2
#REC:upower
#OPT:aspell
#OPT:avahi
#OPT:enchant
#OPT:grantlee
#OPT:jasper
#OPT:mitkrb
#OPT:pcre


cd $SOURCE_DIR

URL=http://download.kde.org/stable/applications/15.04.2/src/kdelibs-4.14.9.tar.xz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/kde/kdelibs-4.14.9.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/kde/kdelibs-4.14.9.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/kde/kdelibs-4.14.9.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/kde/kdelibs-4.14.9.tar.xz || wget -nc http://download.kde.org/stable/applications/15.04.2/src/kdelibs-4.14.9.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/kde/kdelibs-4.14.9.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export KDE_PREFIX=/opt/kde


sed -i "s@{SYSCONF_INSTALL_DIR}/xdg/menus@& RENAME kde-applications.menu@" \
        kded/CMakeLists.txt &&
sed -i "s@applications.menu@kde-&@" \
        kded/kbuildsycoca.cpp


mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX \
      -DSYSCONF_INSTALL_DIR=/etc         \
      -DCMAKE_BUILD_TYPE=Release         \
      -DDOCBOOKXML_CURRENTDTD_DIR=/usr/share/xml/docbook/xml-dtd-4.5 \
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
echo "kdelibs=>`date`" | sudo tee -a $INSTALLED_LIST

