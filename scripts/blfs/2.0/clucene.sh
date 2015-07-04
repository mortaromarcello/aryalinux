#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cmake
#DEP:boost


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/clucene/clucene-core-2.3.3.4.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/clucene-2.3.3.4-contribs_lib-1.patch


TARBALL=clucene-core-2.3.3.4.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../clucene-2.3.3.4-contribs_lib-1.patch &&
mkdir build &&
cd build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DBUILD_CONTRIBS_LIB=ON .. &&
make

cat > 1434987998756.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998756.sh
sudo ./1434987998756.sh
sudo rm -rf 1434987998756.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "clucene=>`date`" | sudo tee -a $INSTALLED_LIST