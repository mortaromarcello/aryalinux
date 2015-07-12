#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc https://s3.amazonaws.com/json-c_releases/releases/json-c-0.12.tar.gz


TARBALL=json-c-0.12.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i s/-Werror// Makefile.in             &&
./configure --prefix=/usr --disable-static &&
make -j1

cat > 1434987998758.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998758.sh
sudo ./1434987998758.sh
sudo rm -rf 1434987998758.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "json-c=>`date`" | sudo tee -a $INSTALLED_LIST