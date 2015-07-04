#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:perl-modules#perl-xml-simple


cd $SOURCE_DIR

wget -nc http://tango.freedesktop.org/releases/icon-naming-utils-0.8.90.tar.bz2


TARBALL=icon-naming-utils-0.8.90.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998768.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998768.sh
sudo ./1434987998768.sh
sudo rm -rf 1434987998768.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "icon-naming-utils=>`date`" | sudo tee -a $INSTALLED_LIST