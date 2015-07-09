#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:systemd
#DEP:gobject-introspection
#DEP:libmbim
#DEP:libqmi
#DEP:polkit
#DEP:vala


cd $SOURCE_DIR

wget -nc http://www.freedesktop.org/software/ModemManager/ModemManager-1.4.4.tar.xz


TARBALL=ModemManager-1.4.4.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-static     &&
make

cat > 1434987998772.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998772.sh
sudo ./1434987998772.sh
sudo rm -rf 1434987998772.sh

cat > 1434987998772.sh << "ENDOFFILE"
systemctl enable ModemManager
ENDOFFILE
chmod a+x 1434987998772.sh
sudo ./1434987998772.sh
sudo rm -rf 1434987998772.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "ModemManager=>`date`" | sudo tee -a $INSTALLED_LIST