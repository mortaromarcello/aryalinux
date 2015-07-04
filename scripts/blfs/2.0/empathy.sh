#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:clutter-gst2
#DEP:clutter-gtk
#DEP:folks
#DEP:gcr
#DEP:itstool
#DEP:libcanberra
#DEP:libnotify
#DEP:pulseaudio
#DEP:telepathy-farstream
#DEP:telepathy-logger
#DEP:webkitgtk2
#DEP:gnome-online-accounts
#DEP:telepathy-mission-control
#DEP:systemd
#DEP:telepathy-gabble
#DEP:telepathy-haze
#DEP:telepathy-idle
#DEP:telepathy-salut


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/empathy/3.12/empathy-3.12.7.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/empathy/3.12/empathy-3.12.7.tar.xz


TARBALL=empathy-3.12.7.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998819.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998819.sh
sudo ./1434987998819.sh
sudo rm -rf 1434987998819.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "empathy=>`date`" | sudo tee -a $INSTALLED_LIST