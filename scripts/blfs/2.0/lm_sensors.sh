#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:which


cd $SOURCE_DIR

wget -nc http://dl.lm-sensors.org/lm-sensors/releases/lm_sensors-3.3.5.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/lm_sensors-3.3.5-upstream_fixes-1.patch


TARBALL=lm_sensors-3.3.5.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../lm_sensors-3.3.5-upstream_fixes-1.patch &&
make PREFIX=/usr        \
     BUILD_STATIC_LIB=0 \
     MANDIR=/usr/share/man

cat > 1434987998771.sh << "ENDOFFILE"
make PREFIX=/usr        \
     BUILD_STATIC_LIB=0 \
     MANDIR=/usr/share/man install &&

install -v -dm755 /usr/share/doc/lm_sensors-3.3.5 &&
cp -rv            README INSTALL doc/* \
                  /usr/share/doc/lm_sensors-3.3.5
ENDOFFILE
chmod a+x 1434987998771.sh
sudo ./1434987998771.sh
sudo rm -rf 1434987998771.sh

cat > 1434987998771.sh << "ENDOFFILE"
sensors-detect
ENDOFFILE
chmod a+x 1434987998771.sh
sudo ./1434987998771.sh
sudo rm -rf 1434987998771.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "lm_sensors=>`date`" | sudo tee -a $INSTALLED_LIST