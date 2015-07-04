#!/bin/bash

set -e
set +h

export PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

TARBALL=initd-tools-0.1.3.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

wget -nc http://people.freedesktop.org/~dbn/initd-tools/releases/initd-tools-0.1.3.tar.gz


tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434309266711.sh << ENDOFFILE
make install
ENDOFFILE
chmod a+x 1434309266711.sh
sudo ./1434309266711.sh
sudo rm -rf 1434309266711.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "initd-tools=>`date`" | sudo tee -a $INSTALLED_LIST