#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://ftp.stack.nl/pub/doxygen/doxygen-1.8.9.1.src.tar.gz
wget -nc ftp://ftp.stack.nl/pub/doxygen/doxygen-1.8.9.1.src.tar.gz


TARBALL=doxygen-1.8.9.1.src.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix /usr \
            --docdir /usr/share/doc/doxygen-1.8.9.1 &&
make

cat > 1434987998775.sh << "ENDOFFILE"
make MAN1DIR=share/man/man1 install
ENDOFFILE
chmod a+x 1434987998775.sh
sudo ./1434987998775.sh
sudo rm -rf 1434987998775.sh

cat > 1434987998775.sh << "ENDOFFILE"
make install_docs
ENDOFFILE
chmod a+x 1434987998775.sh
sudo ./1434987998775.sh
sudo rm -rf 1434987998775.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "doxygen=>`date`" | sudo tee -a $INSTALLED_LIST