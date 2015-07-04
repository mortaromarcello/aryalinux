#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:clutter
#DEP:gnome-desktop
#DEP:libxkbcommon
#DEP:upower
#DEP:zenity
#DEP:gobject-introspection
#DEP:libcanberra
#DEP:startup-notification
#DEP:libinput
#DEP:wayland
#DEP:xorg-server
#DEP:cogl
#DEP:gtk3


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/mutter/3.14/mutter-3.14.3.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/mutter/3.14/mutter-3.14.3.tar.xz


TARBALL=mutter-3.14.3.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998818.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998818.sh
sudo ./1434987998818.sh
sudo rm -rf 1434987998818.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "mutter=>`date`" | sudo tee -a $INSTALLED_LIST