#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtk3
#DEP:libarchive
#DEP:libsoup
#DEP:pango
#DEP:gobject-introspection
#DEP:yaml


cd $SOURCE_DIR

wget -nc http://people.freedesktop.org/~hughsient/appstream-glib/releases/appstream-glib-0.3.4.tar.xz


TARBALL=appstream-glib-0.3.4.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998755.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998755.sh
sudo ./1434987998755.sh
sudo rm -rf 1434987998755.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "appstream-glib=>`date`" | sudo tee -a $INSTALLED_LIST