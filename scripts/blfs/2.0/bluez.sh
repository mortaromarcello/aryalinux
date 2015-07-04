#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:dbus
#DEP:glib2
#DEP:libical


cd $SOURCE_DIR

wget -nc http://www.kernel.org/pub/linux/bluetooth/bluez-5.28.tar.xz
wget -nc ftp://ftp.kernel.org/pub/linux/bluetooth/bluez-5.28.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/bluez-5.28-obexd_without_systemd-1.patch


TARBALL=bluez-5.28.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../bluez-5.28-obexd_without_systemd-1.patch &&
./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --enable-library     &&
make

cat > 1434987998770.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998770.sh
sudo ./1434987998770.sh
sudo rm -rf 1434987998770.sh

cat > 1434987998770.sh << "ENDOFFILE"
install -v -dm755 /etc/bluetooth &&
install -v -m644 src/main.conf /etc/bluetooth/main.conf
ENDOFFILE
chmod a+x 1434987998770.sh
sudo ./1434987998770.sh
sudo rm -rf 1434987998770.sh

cat > 1434987998770.sh << "ENDOFFILE"
install -v -dm755 /usr/share/doc/bluez-5.28 &&
install -v -m644 doc/*.txt /usr/share/doc/bluez-5.28
ENDOFFILE
chmod a+x 1434987998770.sh
sudo ./1434987998770.sh
sudo rm -rf 1434987998770.sh

cat > 1434987998770.sh << "ENDOFFILE"
cat > /etc/bluetooth/rfcomm.conf << "EOF"
ENDOFFILE
chmod a+x 1434987998770.sh
sudo ./1434987998770.sh
sudo rm -rf 1434987998770.sh

cat > 1434987998770.sh << "ENDOFFILE"
cat > /etc/bluetooth/uart.conf << "EOF"
ENDOFFILE
chmod a+x 1434987998770.sh
sudo ./1434987998770.sh
sudo rm -rf 1434987998770.sh

cat > 1434987998770.sh << "ENDOFFILE"
systemctl enable bluetooth
ENDOFFILE
chmod a+x 1434987998770.sh
sudo ./1434987998770.sh
sudo rm -rf 1434987998770.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "bluez=>`date`" | sudo tee -a $INSTALLED_LIST