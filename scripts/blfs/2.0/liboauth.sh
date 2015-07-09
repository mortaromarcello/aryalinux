#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:curl
#DEP:openssl
#DEP:nss


cd $SOURCE_DIR

wget -nc http://sourceforge.net/projects/liboauth/files/liboauth-1.0.3.tar.gz


TARBALL=liboauth-1.0.3.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998747.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998747.sh
sudo ./1434987998747.sh
sudo rm -rf 1434987998747.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "liboauth=>`date`" | sudo tee -a $INSTALLED_LIST