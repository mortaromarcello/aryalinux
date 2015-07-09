#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:curl
#DEP:libxslt


cd $SOURCE_DIR

wget -nc http://download.librdf.org/source/raptor2-2.0.15.tar.gz


TARBALL=raptor2-2.0.15.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998772.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998772.sh
sudo ./1434987998772.sh
sudo rm -rf 1434987998772.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "raptor=>`date`" | sudo tee -a $INSTALLED_LIST