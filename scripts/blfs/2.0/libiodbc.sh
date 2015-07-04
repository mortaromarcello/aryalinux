#!/bin/bash

set -e
set +h

export PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtk2


cd $SOURCE_DIR

TARBALL=libiodbc-3.52.10.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

wget -nc http://downloads.sourceforge.net/project/iodbc/iodbc/3.52.10/libiodbc-3.52.10.tar.gz


tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr                   \
            --with-iodbc-inidir=/etc/iodbc  \
            --includedir=/usr/include/iodbc \
            --disable-libodbc               \
            --disable-static                &&
make

cat > 1434309266687.sh << ENDOFFILE
make install
ENDOFFILE
chmod a+x 1434309266687.sh
sudo ./1434309266687.sh
sudo rm -rf 1434309266687.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libiodbc=>`date`" | sudo tee -a $INSTALLED_LIST