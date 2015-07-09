#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:glib2


cd $SOURCE_DIR

wget -nc https://launchpad.net/libzeitgeist/0.3/0.3.18/+download/libzeitgeist-0.3.18.tar.gz


TARBALL=libzeitgeist-0.3.18.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i  "s|/doc/libzeitgeist|&-0.3.18|" Makefile.in &&

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998763.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998763.sh
sudo ./1434987998763.sh
sudo rm -rf 1434987998763.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libzeitgeist=>`date`" | sudo tee -a $INSTALLED_LIST