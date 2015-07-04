#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:alsa-lib


cd $SOURCE_DIR

wget -nc http://alsa.cybermirror.org/utils/alsa-utils-1.0.28.tar.bz2
wget -nc ftp://ftp.alsa-project.org/pub/utils/alsa-utils-1.0.28.tar.bz2


TARBALL=alsa-utils-1.0.28.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --disable-alsaconf --disable-xmlto &&
make

cat > 1434987998831.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998831.sh
sudo ./1434987998831.sh
sudo rm -rf 1434987998831.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "alsa-utils=>`date`" | sudo tee -a $INSTALLED_LIST