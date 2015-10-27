#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libXau
#DEP:xcb-proto
#DEP:libXdmcp


cd $SOURCE_DIR

wget -nc http://xcb.freedesktop.org/dist/libxcb-1.11.tar.bz2


TARBALL=libxcb-1.11.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed "s/pthread-stubs//" -i configure &&
./configure $XORG_CONFIG    \
            --enable-xinput \
            --docdir='${datadir}'/doc/libxcb-1.11 &&
make

cat > 1434987998789.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998789.sh
sudo ./1434987998789.sh
sudo rm -rf 1434987998789.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libxcb=>`date`" | sudo tee -a $INSTALLED_LIST