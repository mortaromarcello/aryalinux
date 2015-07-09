#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cracklib


cd $SOURCE_DIR

wget -nc https://fedorahosted.org/releases/l/i/libpwquality/libpwquality-1.2.4.tar.bz2


TARBALL=libpwquality-1.2.4.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr             \
            --sysconfdir=/etc         \
            --disable-python-bindings \
            --disable-static          \
            --with-securedir=/lib/security &&
make

cat > 1434987998747.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998747.sh
sudo ./1434987998747.sh
sudo rm -rf 1434987998747.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libpwquality=>`date`" | sudo tee -a $INSTALLED_LIST