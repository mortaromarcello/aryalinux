#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libburn
#DEP:libisofs


cd $SOURCE_DIR

wget -nc http://files.libburnia-project.org/releases/libisoburn-1.3.8.tar.gz


TARBALL=libisoburn-1.3.8.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr              \
            --disable-static           \
            --enable-pkg-check-modules &&
make

cat > 1434987998840.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998840.sh
sudo ./1434987998840.sh
sudo rm -rf 1434987998840.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libisoburn=>`date`" | sudo tee -a $INSTALLED_LIST