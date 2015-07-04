#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:pango
#DEP:installing


cd $SOURCE_DIR

wget -nc http://openbox.org/dist/openbox/openbox-3.5.2.tar.gz


TARBALL=openbox-3.5.2.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --docdir=/usr/share/doc/openbox-3.5.2 &&
make

2to3 -w data/autostart/openbox-xdg-autostart &&
sed 's/python/python3/' -i data/autostart/openbox-xdg-autostart

cat > 1434987998796.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998796.sh
sudo ./1434987998796.sh
sudo rm -rf 1434987998796.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "openbox=>`date`" | sudo tee -a $INSTALLED_LIST