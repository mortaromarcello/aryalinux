#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:freetype2
#DEP:libjpeg
#DEP:libpng
#DEP:libtiff
#DEP:lcms2


cd $SOURCE_DIR

wget -nc http://downloads.ghostscript.com/public/ghostscript-9.15.tar.bz2
wget -nc http://downloads.sourceforge.net/gs-fonts/ghostscript-fonts-std-8.11.tar.gz
wget -nc http://downloads.sourceforge.net/gs-fonts/gnu-gs-fonts-other-6.0.tar.gz


TARBALL=ghostscript-9.15.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i 's/ZLIBDIR=src/ZLIBDIR=$includedir/' configure.ac configure &&
rm -rf expat freetype lcms2 jpeg libpng zlib

./configure --prefix=/usr           \
            --disable-compile-inits \
            --enable-dynamic        \
            --with-system-libtiff &&
make

make so

cat > 1434987998840.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998840.sh
sudo ./1434987998840.sh
sudo rm -rf 1434987998840.sh

cat > 1434987998840.sh << "ENDOFFILE"
make soinstall
ENDOFFILE
chmod a+x 1434987998840.sh
sudo ./1434987998840.sh
sudo rm -rf 1434987998840.sh

cat > 1434987998840.sh << "ENDOFFILE"
ln -sfv ../ghostscript/9.15/doc /usr/share/doc/ghostscript-9.15
ENDOFFILE
chmod a+x 1434987998840.sh
sudo ./1434987998840.sh
sudo rm -rf 1434987998840.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gs=>`date`" | sudo tee -a $INSTALLED_LIST