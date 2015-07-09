#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:python2
#DEP:cairo


cd $SOURCE_DIR

wget -nc http://cairographics.org/releases/py2cairo-1.10.0.tar.bz2


TARBALL=py2cairo-1.10.0.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./waf configure --prefix=/usr &&
./waf build

cat > 1434987998777.sh << "ENDOFFILE"
./waf install
ENDOFFILE
chmod a+x 1434987998777.sh
sudo ./1434987998777.sh
sudo rm -rf 1434987998777.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "python-modules#py2cairo=>`date`" | sudo tee -a $INSTALLED_LIST