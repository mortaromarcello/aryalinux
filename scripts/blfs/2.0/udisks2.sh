#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libatasmart
#DEP:libxslt
#DEP:polkit
#DEP:systemd


cd $SOURCE_DIR

wget -nc http://udisks.freedesktop.org/releases/udisks-2.1.4.tar.bz2


TARBALL=udisks-2.1.4.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-static     &&
make

cat > 1434987998773.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998773.sh
sudo ./1434987998773.sh
sudo rm -rf 1434987998773.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "udisks2=>`date`" | sudo tee -a $INSTALLED_LIST