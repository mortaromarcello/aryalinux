#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://fy.chalmers.se/~appro/linux/DVD+RW/tools/dvd+rw-tools-7.1.tar.gz


TARBALL=dvd+rw-tools-7.1.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i '/stdlib/a #include <limits.h>' transport.hxx &&
sed -i 's#mkisofs"#xorrisofs"#' growisofs.c &&
sed -i 's#mkisofs#xorrisofs#;s#MKISOFS#XORRISOFS#' growisofs.1 &&

make all rpl8 btcflash

cat > 1434987998839.sh << "ENDOFFILE"
make prefix=/usr install &&
install -v -m644 -D index.html \
    /usr/share/doc/dvd+rw-tools-7.1/index.html
ENDOFFILE
chmod a+x 1434987998839.sh
sudo ./1434987998839.sh
sudo rm -rf 1434987998839.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "dvd-rw-tools=>`date`" | sudo tee -a $INSTALLED_LIST