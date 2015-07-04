#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:dbus-glib
#DEP:libxml2
#DEP:gobject-introspection
#DEP:gtk3
#DEP:polkit


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/GConf/3.2/GConf-3.2.6.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/GConf/3.2/GConf-3.2.6.tar.xz


TARBALL=GConf-3.2.6.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --disable-orbit \
            --disable-static &&
make

cat > 1434987998813.sh << "ENDOFFILE"
make install &&
ln -sfv gconf.xml.defaults /etc/gconf/gconf.xml.system
ENDOFFILE
chmod a+x 1434987998813.sh
sudo ./1434987998813.sh
sudo rm -rf 1434987998813.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "GConf=>`date`" | sudo tee -a $INSTALLED_LIST