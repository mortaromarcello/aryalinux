#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:evolution-data-server
#DEP:gnome-icon-theme
#DEP:adwaita-icon-theme
#DEP:gtkhtml
#DEP:itstool
#DEP:libgdata
#DEP:shared-mime-info
#DEP:webkitgtk2
#DEP:bogofilter
#DEP:gnome-desktop
#DEP:highlight
#DEP:libcanberra
#DEP:libgweather
#DEP:libnotify


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/evolution/3.12/evolution-3.12.11.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/evolution/3.12/evolution-3.12.11.tar.xz


TARBALL=evolution-3.12.11.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr         \
            --sysconfdir=/etc     \
            --disable-gtkspell    \
            --disable-pst-import  \
            --disable-spamassassin &&
make

cat > 1434987998819.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998819.sh
sudo ./1434987998819.sh
sudo rm -rf 1434987998819.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "evolution=>`date`" | sudo tee -a $INSTALLED_LIST