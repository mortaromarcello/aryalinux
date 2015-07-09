#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cmake
#DEP:python2
#DEP:doxygen
#DEP:python-modules#Jinja2
#DEP:python-modules#PyYAML


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/frameworks/5.7/kapidox-5.7.0.tar.xz
wget -nc ftp://ftp.kde.org/pub/kde/stable/frameworks/5.7/kapidox-5.7.0.tar.xz


TARBALL=kapidox-5.7.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX .. &&
make

cat > 1434987998802.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998802.sh
sudo ./1434987998802.sh
sudo rm -rf 1434987998802.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "kapidox=>`date`" | sudo tee -a $INSTALLED_LIST