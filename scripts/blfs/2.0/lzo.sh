#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://www.oberhumer.com/opensource/lzo/download/lzo-2.09.tar.gz


TARBALL=lzo-2.09.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr                    \
            --enable-shared                  \
            --disable-static                 \
            --docdir=/usr/share/doc/lzo-2.09 &&
make

cat > 1434987998763.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998763.sh
sudo ./1434987998763.sh
sudo rm -rf 1434987998763.sh

mv -v /usr/lib/liblzo2.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/liblzo2.so) /usr/lib/liblzo2.so


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "lzo=>`date`" | sudo tee -a $INSTALLED_LIST