#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:x7lib
#DEP:hicolor-icon-theme
#DEP:libjpeg
#DEP:libpng


cd $SOURCE_DIR

wget -nc http://fltk.org/pub/fltk/1.3.3/fltk-1.3.3-source.tar.gz


TARBALL=fltk-1.3.3-source.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i -e '/cat./d' documentation/Makefile &&
./configure --prefix=/usr --enable-shared  &&
make

cat > 1434987998793.sh << "ENDOFFILE"
make docdir=/usr/share/doc/fltk-1.3.3 install
ENDOFFILE
chmod a+x 1434987998793.sh
sudo ./1434987998793.sh
sudo rm -rf 1434987998793.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "fltk=>`date`" | sudo tee -a $INSTALLED_LIST