#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/hdparm/hdparm-9.45.tar.gz


TARBALL=hdparm-9.45.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

make

cat > 1434987998771.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998771.sh
sudo ./1434987998771.sh
sudo rm -rf 1434987998771.sh

cat > 1434987998771.sh << "ENDOFFILE"
make binprefix=/usr install
ENDOFFILE
chmod a+x 1434987998771.sh
sudo ./1434987998771.sh
sudo rm -rf 1434987998771.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "hdparm=>`date`" | sudo tee -a $INSTALLED_LIST