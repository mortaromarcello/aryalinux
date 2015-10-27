#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:json-c
#DEP:libsndfile
#DEP:alsa-lib
#DEP:dbus
#DEP:glib2
#DEP:openssl
#DEP:speex
#DEP:x7lib


cd $SOURCE_DIR

wget -nc http://freedesktop.org/software/pulseaudio/releases/pulseaudio-6.0.tar.xz


TARBALL=pulseaudio-6.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

find . -name "Makefile.in" | xargs sed -i "s|(libdir)/@PACKAGE@|(libdir)/pulse|" &&
./configure --prefix=/usr         \
            --sysconfdir=/etc     \
            --localstatedir=/var  \
            --disable-bluez4      \
            --disable-rpath       \
            --with-module-dir=/usr/lib/pulse/modules &&
make

cat > 1434987998837.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998837.sh
sudo ./1434987998837.sh
sudo rm -rf 1434987998837.sh

cat > 1434987998837.sh << "ENDOFFILE"
rm -fv /etc/dbus-1/system.d/pulseaudio-system.conf
ENDOFFILE
chmod a+x 1434987998837.sh
sudo ./1434987998837.sh
sudo rm -rf 1434987998837.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "pulseaudio=>`date`" | sudo tee -a $INSTALLED_LIST