#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/check/check-0.9.14.tar.gz


TARBALL=check-0.9.14.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998774.sh << "ENDOFFILE"
make docdir=/usr/share/doc/check-0.9.14 install
ENDOFFILE
chmod a+x 1434987998774.sh
sudo ./1434987998774.sh
sudo rm -rf 1434987998774.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "check=>`date`" | sudo tee -a $INSTALLED_LIST