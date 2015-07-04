#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtk2
#DEP:gtk3


cd $SOURCE_DIR

wget -nc http://www.bennewitz.com/bluefish/stable/source/bluefish-2.2.7.tar.bz2


TARBALL=bluefish-2.2.7.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --docdir=/usr/share/doc/bluefish-2.2.7 &&
make

cat > 1434987998753.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998753.sh
sudo ./1434987998753.sh
sudo rm -rf 1434987998753.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "bluefish=>`date`" | sudo tee -a $INSTALLED_LIST