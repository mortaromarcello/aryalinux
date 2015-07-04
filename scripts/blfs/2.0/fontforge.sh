#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cairo
#DEP:freetype2
#DEP:harfbuzz
#DEP:gtk2
#DEP:libxml2
#DEP:x7lib


cd $SOURCE_DIR

wget -nc https://github.com/fontforge/fontforge/releases/download/20141126/fontforge-2014-11-26-Unix-Source.tar.gz


TARBALL=fontforge-2014-11-26-Unix-Source.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

rm -fv m4/argz.m4   &&
./bootstrap --force &&
./configure --prefix=/usr     \
            --enable-gtk2-use \
            --disable-static  \
            --docdir=/usr/share/doc/fontforge-20141126 &&
make

cat > 1434987998829.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998829.sh
sudo ./1434987998829.sh
sudo rm -rf 1434987998829.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "fontforge=>`date`" | sudo tee -a $INSTALLED_LIST