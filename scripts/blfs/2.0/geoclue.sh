#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:dbus-glib
#DEP:GConf
#DEP:libxslt
#DEP:libsoup
#DEP:networkmanager


cd $SOURCE_DIR

wget -nc https://launchpad.net/geoclue/trunk/0.12/+download/geoclue-0.12.0.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/geoclue-0.12.0-gpsd_fix-1.patch


TARBALL=geoclue-0.12.0.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../geoclue-0.12.0-gpsd_fix-1.patch &&
sed -i "s@ -Werror@@" configure &&
sed -i "s@libnm_glib@libnm-glib@g" configure &&
sed -i "s@geoclue/libgeoclue.la@& -lgthread-2.0@g" \
       providers/skyhook/Makefile.in &&
./configure --prefix=/usr --disable-static &&
make

cat > 1434987998784.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998784.sh
sudo ./1434987998784.sh
sudo rm -rf 1434987998784.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "geoclue=>`date`" | sudo tee -a $INSTALLED_LIST