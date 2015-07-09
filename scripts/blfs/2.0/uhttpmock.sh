#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libsoup
#DEP:gobject-introspection
#DEP:vala


cd $SOURCE_DIR

wget -nc http://tecnocode.co.uk/downloads/uhttpmock/uhttpmock-0.3.3.tar.xz


TARBALL=uhttpmock-0.3.3.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998785.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998785.sh
sudo ./1434987998785.sh
sudo rm -rf 1434987998785.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "uhttpmock=>`date`" | sudo tee -a $INSTALLED_LIST