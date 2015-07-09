#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cmake
#DEP:qt5


cd $SOURCE_DIR

wget -nc http://downloads.grantlee.org/grantlee-5.0.0.tar.gz


TARBALL=grantlee-5.0.0.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DBUILD_TESTS=OFF           \
      .. &&
make

cat > 1434987998801.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998801.sh
sudo ./1434987998801.sh
sudo rm -rf 1434987998801.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "grantlee=>`date`" | sudo tee -a $INSTALLED_LIST