#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.0.tar.xz


TARBALL=ruby-2.2.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr   \
            --enable-shared \
            --docdir=/usr/share/doc/ruby-2.2.0

make

cat > 1434987998778.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998778.sh
sudo ./1434987998778.sh
sudo rm -rf 1434987998778.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "ruby=>`date`" | sudo tee -a $INSTALLED_LIST