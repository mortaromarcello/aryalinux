#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtk2
#DEP:gobject-introspection
#DEP:python-modules#pygtk


cd $SOURCE_DIR

wget -nc http://pkgs.fedoraproject.org/repo/pkgs/keybinder/keybinder-0.3.0.tar.gz/2a0aed62ba14d1bf5c79707e20cb4059/keybinder-0.3.0.tar.gz


TARBALL=keybinder-0.3.0.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-lua &&
make

cat > 1434987998795.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998795.sh
sudo ./1434987998795.sh
sudo rm -rf 1434987998795.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "keybinder2=>`date`" | sudo tee -a $INSTALLED_LIST