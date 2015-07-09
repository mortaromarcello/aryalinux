#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:attica
#DEP:automoc4
#DEP:docbook
#DEP:docbook-xsl
#DEP:giflib
#DEP:libdbusmenu-qt
#DEP:libjpeg
#DEP:libpng
#DEP:phonon
#DEP:shared-mime-info
#DEP:strigi
#DEP:openssl
#DEP:polkit-qt
#DEP:qca
#DEP:udisks
#DEP:udisks2
#DEP:upower


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/4.14.3/src/kdelibs-4.14.3.tar.xz


TARBALL=kdelibs-4.14.3.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i "s:BSD_SOURCE:DEFAULT_SOURCE:g"      \
       cmake/modules/FindKDE4Internal.cmake \
       kjsembed/qtonly/FindQJSInternal.cmake

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
make

cat > 1434987998798.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998798.sh
sudo ./1434987998798.sh
sudo rm -rf 1434987998798.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "kdelibs=>`date`" | sudo tee -a $INSTALLED_LIST