#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://ftp.kernel.org/pub/linux/kernel/people/jeffm/reiserfsprogs/v3.6.24/reiserfsprogs-3.6.24.tar.xz


TARBALL=reiserfsprogs-3.6.24.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sbindir=/sbin &&
make

cat > 1434987998753.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998753.sh
sudo ./1434987998753.sh
sudo rm -rf 1434987998753.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "reiserfs=>`date`" | sudo tee -a $INSTALLED_LIST