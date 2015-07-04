#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://www.rarlab.com/rar/unrarsrc-5.2.6.tar.gz


TARBALL=unrarsrc-5.2.6.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

make

cat > 1434987998773.sh << "ENDOFFILE"
install -v -m755 unrar /usr/bin
ENDOFFILE
chmod a+x 1434987998773.sh
sudo ./1434987998773.sh
sudo rm -rf 1434987998773.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "unrar=>`date`" | sudo tee -a $INSTALLED_LIST