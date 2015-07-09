#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:qt4
#DEP:cmake


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/qjson/qjson-0.8.1.tar.bz2


TARBALL=qjson-0.8.1.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir build &&
cd build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      .. &&
make

cat > 1434987998764.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998764.sh
sudo ./1434987998764.sh
sudo rm -rf 1434987998764.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "qjson=>`date`" | sudo tee -a $INSTALLED_LIST