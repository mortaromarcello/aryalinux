#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cmake


cd $SOURCE_DIR

wget -nc https://github.com/libical/libical/releases/download/v1.0.1/libical-1.0.1.tar.gz


TARBALL=libical-1.0.1.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir build &&
cd build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DSHARED_ONLY=yes           \
      .. &&
make

cat > 1434987998761.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998761.sh
sudo ./1434987998761.sh
sudo rm -rf 1434987998761.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libical=>`date`" | sudo tee -a $INSTALLED_LIST