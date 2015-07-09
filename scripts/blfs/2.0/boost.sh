#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/boost/boost_1_57_0.tar.bz2


TARBALL=boost_1_57_0.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./bootstrap.sh --prefix=/usr &&
./b2 stage threading=multi link=shared

cat > 1434987998756.sh << "ENDOFFILE"
./b2 install threading=multi link=shared
ENDOFFILE
chmod a+x 1434987998756.sh
sudo ./1434987998756.sh
sudo rm -rf 1434987998756.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "boost=>`date`" | sudo tee -a $INSTALLED_LIST