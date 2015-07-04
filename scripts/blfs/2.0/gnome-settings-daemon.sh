#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:colord
#DEP:geoclue2
#DEP:gnome-desktop
#DEP:libcanberra
#DEP:libgweather
#DEP:libnotify
#DEP:librsvg
#DEP:libwacom
#DEP:pulseaudio
#DEP:upower
#DEP:x7driver#xorg-wacom-driver
#DEP:cups
#DEP:networkmanager
#DEP:nss
#DEP:wayland


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-settings-daemon/3.14/gnome-settings-daemon-3.14.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-settings-daemon/3.14/gnome-settings-daemon-3.14.2.tar.xz


TARBALL=gnome-settings-daemon-3.14.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  &&
make

cat > 1434987998817.sh << "ENDOFFILE"
make udevrulesdir=/lib/udev/rules.d install
ENDOFFILE
chmod a+x 1434987998817.sh
sudo ./1434987998817.sh
sudo rm -rf 1434987998817.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gnome-settings-daemon=>`date`" | sudo tee -a $INSTALLED_LIST