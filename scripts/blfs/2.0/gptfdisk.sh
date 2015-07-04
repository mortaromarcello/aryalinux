#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/project/gptfdisk/gptfdisk/0.8.10/gptfdisk-0.8.10.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/gptfdisk-0.8.10-convenience-1.patch


TARBALL=gptfdisk-0.8.10.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../gptfdisk-0.8.10-convenience-1.patch &&
make

cat > 1434987998752.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998752.sh
sudo ./1434987998752.sh
sudo rm -rf 1434987998752.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gptfdisk=>`date`" | sudo tee -a $INSTALLED_LIST