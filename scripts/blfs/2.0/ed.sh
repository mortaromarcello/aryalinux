#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libarchive


cd $SOURCE_DIR

wget -nc http://ftp.gnu.org/pub/gnu/ed/ed-1.10.tar.lz
wget -nc ftp://ftp.gnu.org/pub/gnu/ed/ed-1.10.tar.lz


TARBALL=ed-1.10.tar.lz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --bindir=/bin &&
make

cat > 1434987998753.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998753.sh
sudo ./1434987998753.sh
sudo rm -rf 1434987998753.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "ed=>`date`" | sudo tee -a $INSTALLED_LIST