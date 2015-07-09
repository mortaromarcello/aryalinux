#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libpng
#DEP:imlib2
#DEP:curl


cd $SOURCE_DIR

wget -nc http://feh.finalrewind.org/feh-2.12.tar.bz2


TARBALL=feh-2.12.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i "s:doc/feh:&-2.12:" config.mk &&
make PREFIX=/usr

cat > 1434987998829.sh << "ENDOFFILE"
make PREFIX=/usr install
ENDOFFILE
chmod a+x 1434987998829.sh
sudo ./1434987998829.sh
sudo rm -rf 1434987998829.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "feh=>`date`" | sudo tee -a $INSTALLED_LIST