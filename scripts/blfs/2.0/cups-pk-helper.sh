#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:polkit


cd $SOURCE_DIR

wget -nc http://www.freedesktop.org/software/cups-pk-helper/releases/cups-pk-helper-0.2.5.tar.xz


TARBALL=cups-pk-helper-0.2.5.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc &&
make

cat > 1434987998771.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998771.sh
sudo ./1434987998771.sh
sudo rm -rf 1434987998771.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "cups-pk-helper=>`date`" | sudo tee -a $INSTALLED_LIST