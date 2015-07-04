#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:dbus-glib
#DEP:libatasmart
#DEP:lvm2
#DEP:parted
#DEP:polkit
#DEP:sg3_utils
#DEP:systemd


cd $SOURCE_DIR

wget -nc http://hal.freedesktop.org/releases/udisks-1.0.5.tar.gz


TARBALL=udisks-1.0.5.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var &&
make

cat > 1434987998773.sh << "ENDOFFILE"
make profiledir=/etc/bash_completion.d install
ENDOFFILE
chmod a+x 1434987998773.sh
sudo ./1434987998773.sh
sudo rm -rf 1434987998773.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "udisks=>`date`" | sudo tee -a $INSTALLED_LIST