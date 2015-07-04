#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://www.kernel.org/pub/linux/utils/raid/mdadm/mdadm-3.3.2.tar.xz


TARBALL=mdadm-3.3.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i 's/Wall -Werror/Wall/' Makefile

make

cat > 1434987998752.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998752.sh
sudo ./1434987998752.sh
sudo rm -rf 1434987998752.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "mdadm=>`date`" | sudo tee -a $INSTALLED_LIST