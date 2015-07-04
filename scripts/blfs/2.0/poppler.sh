#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:fontconfig
#DEP:cairo
#DEP:libjpeg
#DEP:libpng
#DEP:openjpeg


cd $SOURCE_DIR

wget -nc http://poppler.freedesktop.org/poppler-0.31.0.tar.xz
wget -nc http://poppler.freedesktop.org/poppler-data-0.4.7.tar.gz


TARBALL=poppler-0.31.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr         \
            --sysconfdir=/etc     \
            --disable-static      \
            --enable-xpdf-headers \
            --with-testdatadir=$PWD/testfiles &&
make

cat > 1434987998767.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998767.sh
sudo ./1434987998767.sh
sudo rm -rf 1434987998767.sh

cat > 1434987998767.sh << "ENDOFFILE"
install -v -dm755        /usr/share/doc/poppler-0.31.0 &&
install -v -m644 README* /usr/share/doc/poppler-0.31.0
ENDOFFILE
chmod a+x 1434987998767.sh
sudo ./1434987998767.sh
sudo rm -rf 1434987998767.sh

tar -xf ../poppler-data-0.4.7.tar.gz &&
cd poppler-data-0.4.7

cat > 1434987998767.sh << "ENDOFFILE"
make prefix=/usr install
ENDOFFILE
chmod a+x 1434987998767.sh
sudo ./1434987998767.sh
sudo rm -rf 1434987998767.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "poppler=>`date`" | sudo tee -a $INSTALLED_LIST