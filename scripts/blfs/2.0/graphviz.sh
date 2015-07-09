#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:freetype2
#DEP:fontconfig
#DEP:freeglut
#DEP:gdk-pixbuf
#DEP:libjpeg
#DEP:libpng
#DEP:librsvg
#DEP:pango
#DEP:x7lib


cd $SOURCE_DIR

wget -nc http://graphviz.org/pub/graphviz/stable/SOURCES/graphviz-2.38.0.tar.gz


TARBALL=graphviz-2.38.0.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i "s:ruby-1.9:ruby-2.2:g" configure

./configure --prefix=/usr &&
make

cat > 1434987998768.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998768.sh
sudo ./1434987998768.sh
sudo rm -rf 1434987998768.sh

cat > 1434987998768.sh << "ENDOFFILE"
ln -sfv /usr/share/graphviz/doc \
        /usr/share/doc/graphviz-2.38.0
ENDOFFILE
chmod a+x 1434987998768.sh
sudo ./1434987998768.sh
sudo rm -rf 1434987998768.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "graphviz=>`date`" | sudo tee -a $INSTALLED_LIST