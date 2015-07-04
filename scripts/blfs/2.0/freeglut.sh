#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:glu


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/freeglut/freeglut-2.8.1.tar.gz


TARBALL=freeglut-2.8.1.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998793.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998793.sh
sudo ./1434987998793.sh
sudo rm -rf 1434987998793.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "freeglut=>`date`" | sudo tee -a $INSTALLED_LIST