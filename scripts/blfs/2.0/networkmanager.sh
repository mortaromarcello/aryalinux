#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:dbus-glib
#DEP:libndp
#DEP:libnl
#DEP:nss
#DEP:gnutls
#DEP:systemd
#DEP:dhcpcd
#DEP:gobject-introspection
#DEP:iptables
#DEP:libsoup
#DEP:newt
#DEP:polkit
#DEP:vala


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.0/NetworkManager-1.0.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.0/NetworkManager-1.0.0.tar.xz


TARBALL=NetworkManager-1.0.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr                   \
            --sysconfdir=/etc               \
            --localstatedir=/var            \
            --disable-ppp                   \
            --with-nmtui                    \
            --with-session-tracking=systemd \
            --with-systemdsystemunitdir=/lib/systemd/system \
            --docdir=/usr/share/doc/NetworkManager-1.0.0    &&
make

cat > 1434987998783.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998783.sh
sudo ./1434987998783.sh
sudo rm -rf 1434987998783.sh

cat > 1434987998783.sh << "ENDOFFILE"
cat >> /etc/NetworkManager/NetworkManager.conf << "EOF"
[main]
plugins=keyfile
EOF
ENDOFFILE
chmod a+x 1434987998783.sh
sudo ./1434987998783.sh
sudo rm -rf 1434987998783.sh

cat > 1434987998783.sh << "ENDOFFILE"
systemctl enable NetworkManager
ENDOFFILE
chmod a+x 1434987998783.sh
sudo ./1434987998783.sh
sudo rm -rf 1434987998783.sh

cat > 1434987998783.sh << "ENDOFFILE"
systemctl enable NetworkManager-wait-online
ENDOFFILE
chmod a+x 1434987998783.sh
sudo ./1434987998783.sh
sudo rm -rf 1434987998783.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "networkmanager=>`date`" | sudo tee -a $INSTALLED_LIST