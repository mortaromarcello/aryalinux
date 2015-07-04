#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.xvid.org/downloads/xvidcore-1.3.3.tar.gz


TARBALL=xvidcore-1.3.3.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cd build/generic &&
sed -i 's/^LN_S=@LN_S@/& -f -v/' platform.inc.in &&
./configure --prefix=/usr &&
make

cat > 1434987998837.sh << "ENDOFFILE"
sed -i '/libdir.*STATIC_LIB/ s/^/#/' Makefile &&
make install &&

chmod -v 755 /usr/lib/libxvidcore.so.4.3 &&

install -v -m755 -d /usr/share/doc/xvidcore-1.3.3/examples &&
install -v -m644 ../../doc/* /usr/share/doc/xvidcore-1.3.3 &&
install -v -m644 ../../examples/* \
    /usr/share/doc/xvidcore-1.3.3/examples
ENDOFFILE
chmod a+x 1434987998837.sh
sudo ./1434987998837.sh
sudo rm -rf 1434987998837.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "xvid=>`date`" | sudo tee -a $INSTALLED_LIST