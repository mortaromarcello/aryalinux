#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:accountsservice
#DEP:clutter-gtk
#DEP:colord-gtk
#DEP:gnome-online-accounts
#DEP:gnome-settings-daemon
#DEP:grilo
#DEP:libgtop
#DEP:libpwquality
#DEP:mitkrb
#DEP:shared-mime-info
#DEP:cheese
#DEP:cups
#DEP:samba
#DEP:gnome-bluetooth
#DEP:ibus
#DEP:ModemManager
#DEP:network-manager-applet


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-control-center/3.14/gnome-control-center-3.14.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-control-center/3.14/gnome-control-center-3.14.2.tar.xz


TARBALL=gnome-control-center-3.14.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998818.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998818.sh
sudo ./1434987998818.sh
sudo rm -rf 1434987998818.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gnome-control-center=>`date`" | sudo tee -a $INSTALLED_LIST