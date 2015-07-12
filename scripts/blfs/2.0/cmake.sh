#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:curl
#DEP:libarchive


cd $SOURCE_DIR

wget -nc http://www.cmake.org/files/v3.1/cmake-3.1.3.tar.gz


TARBALL=cmake-3.1.3.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./bootstrap --prefix=/usr       \
            --system-libs       \
            --mandir=/share/man \
            --docdir=/share/doc/cmake-3.1.3 &&
make

cat > 1434987998774.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998774.sh
sudo ./1434987998774.sh
sudo rm -rf 1434987998774.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "cmake=>`date`" | sudo tee -a $INSTALLED_LIST