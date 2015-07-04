#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:dconf
#DEP:iso-codes
#DEP:gobject-introspection
#DEP:gtk2
#DEP:libnotify
#DEP:vala


cd $SOURCE_DIR

wget -nc https://github.com/ibus/ibus/releases/download/1.5.9/ibus-1.5.9.tar.gz


TARBALL=ibus-1.5.9.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc &&
make

cat > 1434987998768.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998768.sh
sudo ./1434987998768.sh
sudo rm -rf 1434987998768.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "ibus=>`date`" | sudo tee -a $INSTALLED_LIST