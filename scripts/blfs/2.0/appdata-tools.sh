#!/bin/bash

set -e
set +h

export PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:appstream-glib
#DEP:gobject-introspection


cd $SOURCE_DIR

TARBALL=appdata-tools-0.1.8.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

wget -nc http://people.freedesktop.org/~hughsient/releases/appdata-tools-0.1.8.tar.xz


tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434309266704.sh << ENDOFFILE
make install
ENDOFFILE
chmod a+x 1434309266704.sh
sudo ./1434309266704.sh
sudo rm -rf 1434309266704.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "appdata-tools=>`date`" | sudo tee -a $INSTALLED_LIST