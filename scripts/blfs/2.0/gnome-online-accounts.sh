#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gcr
#DEP:json-glib
#DEP:librest
#DEP:telepathy-glib
#DEP:webkitgtk2
#DEP:gobject-introspection


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-online-accounts/3.14/gnome-online-accounts-3.14.3.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-online-accounts/3.14/gnome-online-accounts-3.14.3.tar.xz


TARBALL=gnome-online-accounts-3.14.3.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998814.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998814.sh
sudo ./1434987998814.sh
sudo rm -rf 1434987998814.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gnome-online-accounts=>`date`" | sudo tee -a $INSTALLED_LIST