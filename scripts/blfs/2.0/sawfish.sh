#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:rep-gtk
#DEP:which
#DEP:pango


cd $SOURCE_DIR

wget -nc http://download.tuxfamily.org/sawfish/sawfish_1.11.tar.xz


TARBALL=sawfish_1.11.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --with-pango &&
make

cat > 1434987998797.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998797.sh
sudo ./1434987998797.sh
sudo rm -rf 1434987998797.sh

cat >> ~/.xinitrc << "EOF"
exec sawfish
EOF


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "sawfish=>`date`" | sudo tee -a $INSTALLED_LIST