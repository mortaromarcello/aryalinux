#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc https://download.samba.org/pub/talloc/talloc-2.1.1.tar.gz


TARBALL=talloc-2.1.1.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998764.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998764.sh
sudo ./1434987998764.sh
sudo rm -rf 1434987998764.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "talloc=>`date`" | sudo tee -a $INSTALLED_LIST