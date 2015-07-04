#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://macieira.org/qtchooser/qtchooser-39-g4717841.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/qtchooser-39-upstream_fixes-2.patch


TARBALL=qtchooser-39-g4717841.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../qtchooser-39-upstream_fixes-2.patch &&
make

cat > 1434987998769.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998769.sh
sudo ./1434987998769.sh
sudo rm -rf 1434987998769.sh

cat > 1434987998769.sh << "ENDOFFILE"
install -v -dm755 /etc/xdg/qtchooser &&
cat > /etc/xdg/qtchooser/qt4.conf << "EOF"
/usr/lib/qt4/bin
/usr/lib
EOF
cat > /etc/xdg/qtchooser/qt5.conf << "EOF"
/usr/lib/qt5/bin
/usr/lib
EOF
ENDOFFILE
chmod a+x 1434987998769.sh
sudo ./1434987998769.sh
sudo rm -rf 1434987998769.sh

cat > 1434987998769.sh << "ENDOFFILE"
install -v -dm755 /etc/xdg/qtchooser &&
cat > /etc/xdg/qtchooser/qt4.conf << "EOF"
/opt/qt4/lib/qt4/bin
/opt/qt4/lib
EOF
cat > /etc/xdg/qtchooser/qt5.conf << "EOF"
/opt/qt5/lib/qt5/bin
/opt/qt5/lib
EOF
ENDOFFILE
chmod a+x 1434987998769.sh
sudo ./1434987998769.sh
sudo rm -rf 1434987998769.sh

cat > 1434987998769.sh << "ENDOFFILE"
ln -sfv qt4.conf /etc/xdg/qtchooser/default.conf
ENDOFFILE
chmod a+x 1434987998769.sh
sudo ./1434987998769.sh
sudo rm -rf 1434987998769.sh

cat > 1434987998769.sh << "ENDOFFILE"
ln -sfv qt5.conf /etc/xdg/qtchooser/default.conf
ENDOFFILE
chmod a+x 1434987998769.sh
sudo ./1434987998769.sh
sudo rm -rf 1434987998769.sh

export QT_SELECT=qt4

export QT_SELECT=qt5


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "qtchooser=>`date`" | sudo tee -a $INSTALLED_LIST