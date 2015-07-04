#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:clutter
#DEP:gtk3
#DEP:gobject-introspection


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/clutter-gtk/1.6/clutter-gtk-1.6.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/clutter-gtk/1.6/clutter-gtk-1.6.0.tar.xz


TARBALL=clutter-gtk-1.6.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998793.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998793.sh
sudo ./1434987998793.sh
sudo rm -rf 1434987998793.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "clutter-gtk=>`date`" | sudo tee -a $INSTALLED_LIST