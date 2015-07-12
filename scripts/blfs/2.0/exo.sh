#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libxfce4ui
#DEP:libxfce4util
#DEP:perl-modules#perl-uri


cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/xfce/exo/0.10/exo-0.10.2.tar.bz2


TARBALL=exo-0.10.2.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc &&
make

cat > 1434987998823.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998823.sh
sudo ./1434987998823.sh
sudo rm -rf 1434987998823.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "exo=>`date`" | sudo tee -a $INSTALLED_LIST