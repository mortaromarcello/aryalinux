#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cmake
#DEP:gtk2
#DEP:libisoburn
#DEP:cdparanoia
#DEP:cdrdao


cd $SOURCE_DIR

wget -nc http://simpleburn.tuxfamily.org/IMG/bz2/simpleburn-1.6.5.tar.bz2


TARBALL=simpleburn-1.6.5.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i -e 's|DESTINATION doc|DESTINATION share/doc|' CMakeLists.txt &&

mkdir build &&
cd    build &&

cmake -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DBURNING=LIBBURNIA .. &&
make

cat > 1434987998840.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998840.sh
sudo ./1434987998840.sh
sudo rm -rf 1434987998840.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "simpleburn=>`date`" | sudo tee -a $INSTALLED_LIST