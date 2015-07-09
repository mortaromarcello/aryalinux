#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:bluez
#DEP:dbus-glib
#DEP:imagemagick
#DEP:gdk-pixbuf
#DEP:libusb-compat
#DEP:openobex


cd $SOURCE_DIR

wget -nc http://tadas.dailyda.com/software/obex-data-server-0.4.6.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/obex-data-server-0.4.6-build-fixes-1.patch


TARBALL=obex-data-server-0.4.6.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../obex-data-server-0.4.6-build-fixes-1.patch &&

./configure --prefix=/usr --sysconfdir=/etc &&
make

cat > 1434987998772.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998772.sh
sudo ./1434987998772.sh
sudo rm -rf 1434987998772.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "obex-data-server=>`date`" | sudo tee -a $INSTALLED_LIST