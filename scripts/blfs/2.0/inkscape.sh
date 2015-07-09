#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:boost
#DEP:gc
#DEP:gsl
#DEP:gtkmm2
#DEP:gtkmm3
#DEP:
#DEP:libxslt
#DEP:popt
#DEP:lcms2
#DEP:lcms


cd $SOURCE_DIR

wget -nc https://launchpad.net/inkscape/0.91.x/0.91/+download/inkscape-0.91.tar.bz2


TARBALL=inkscape-0.91.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../inkscape-0.91-testfiles-1.patch &&

./configure --prefix=/usr &&
make

cat > 1434987998830.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998830.sh
sudo ./1434987998830.sh
sudo rm -rf 1434987998830.sh

cat > 1434987998830.sh << "ENDOFFILE"
gtk-update-icon-cache &&
update-desktop-database
ENDOFFILE
chmod a+x 1434987998830.sh
sudo ./1434987998830.sh
sudo rm -rf 1434987998830.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "inkscape=>`date`" | sudo tee -a $INSTALLED_LIST