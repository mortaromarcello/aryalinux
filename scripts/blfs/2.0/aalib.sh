#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/aa-project/aalib-1.4rc5.tar.gz


TARBALL=aalib-1.4rc5.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i -e '/AM_PATH_AALIB,/s/AM_PATH_AALIB/[&]/' aalib.m4

./configure --prefix=/usr             \
            --infodir=/usr/share/info \
            --mandir=/usr/share/man   \
            --disable-static          &&
make

cat > 1434987998765.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998765.sh
sudo ./1434987998765.sh
sudo rm -rf 1434987998765.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "aalib=>`date`" | sudo tee -a $INSTALLED_LIST