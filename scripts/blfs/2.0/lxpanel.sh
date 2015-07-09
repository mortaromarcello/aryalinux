#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:keybinder2
#DEP:libwnck2
#DEP:lxmenu-data
#DEP:menu-cache
#DEP:alsa-lib
#DEP:libxml2
#DEP:wireless_tools


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/lxde/lxpanel-0.8.0.tar.xz


TARBALL=lxpanel-0.8.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998826.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998826.sh
sudo ./1434987998826.sh
sudo rm -rf 1434987998826.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "lxpanel=>`date`" | sudo tee -a $INSTALLED_LIST