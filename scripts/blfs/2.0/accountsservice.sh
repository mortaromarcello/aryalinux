#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:polkit
#DEP:gobject-introspection
#DEP:systemd


cd $SOURCE_DIR

wget -nc http://www.freedesktop.org/software/accountsservice/accountsservice-0.6.40.tar.xz


TARBALL=accountsservice-0.6.40.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr            \
            --sysconfdir=/etc        \
            --localstatedir=/var     \
            --enable-admin-group=adm \
            --disable-static         &&
make

cat > 1434987998812.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998812.sh
sudo ./1434987998812.sh
sudo rm -rf 1434987998812.sh

cat > 1434987998812.sh << "ENDOFFILE"
systemctl enable accounts-daemon
ENDOFFILE
chmod a+x 1434987998812.sh
sudo ./1434987998812.sh
sudo rm -rf 1434987998812.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "accountsservice=>`date`" | sudo tee -a $INSTALLED_LIST