#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/giflib/giflib-5.1.1.tar.bz2


TARBALL=giflib-5.1.1.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998765.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998765.sh
sudo ./1434987998765.sh
sudo rm -rf 1434987998765.sh

cat > 1434987998765.sh << "ENDOFFILE"
find doc \( -name Makefile\* -o -name \*.1 \
         -o -name \*.xml \) -exec rm -v {} \; &&

install -v -dm755 /usr/share/doc/giflib-5.1.1 &&
cp -v -R doc/* /usr/share/doc/giflib-5.1.1
ENDOFFILE
chmod a+x 1434987998765.sh
sudo ./1434987998765.sh
sudo rm -rf 1434987998765.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "giflib=>`date`" | sudo tee -a $INSTALLED_LIST