#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:clutter-gst2
#DEP:clutter-gtk
#DEP:gnome-desktop
#DEP:gnome-icon-theme
#DEP:grilo
#DEP:gst10-plugins-bad
#DEP:gst10-plugins-good
#DEP:libpeas
#DEP:totem-pl-parser
#DEP:appstream-glib
#DEP:nautilus
#DEP:vala
#DEP:grilo-plugins
#DEP:gst10-libav
#DEP:gst10-plugins-ugly
#DEP:libdvdcss


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/totem/3.14/totem-3.14.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/totem/3.14/totem-3.14.2.tar.xz


TARBALL=totem-3.14.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998822.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998822.sh
sudo ./1434987998822.sh
sudo rm -rf 1434987998822.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "totem=>`date`" | sudo tee -a $INSTALLED_LIST