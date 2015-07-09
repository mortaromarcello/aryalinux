#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:dbus-glib
#DEP:gtk2
#DEP:libunique
#DEP:lsb-release
#DEP:polkit


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/lxde/lxsession-0.5.2.tar.xz


TARBALL=lxsession-0.5.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-man &&
make

cat > 1434987998827.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998827.sh
sudo ./1434987998827.sh
sudo rm -rf 1434987998827.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "lxsession=>`date`" | sudo tee -a $INSTALLED_LIST