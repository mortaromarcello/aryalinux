#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:which
#DEP:libpng


cd $SOURCE_DIR

TARBALL=freetype-2.5.5.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

wget -nc http://downloads.sourceforge.net/freetype/freetype-2.5.5.tar.bz2
wget -nc http://downloads.sourceforge.net/freetype/freetype-doc-2.5.5.tar.bz2


tar -xf $TARBALL

cd $DIRECTORY

tar -xf ../freetype-doc-2.5.5.tar.bz2 --strip-components=2 -C docs

sed -i  -e "/AUX.*.gxvalid/s@^# @@" \
        -e "/AUX.*.otvalid/s@^# @@" \
        modules.cfg                        &&

sed -ri -e 's:.*(#.*SUBPIXEL.*) .*:\1:' \
        include/config/ftoption.h          &&

./configure --prefix=/usr --disable-static --disable-harfbuzz &&
make

cat > 1434333557766.sh << ENDOFFILE
make install &&
install -v -m755 -d /usr/share/doc/freetype-2.5.5 &&
cp -v -R docs/*     /usr/share/doc/freetype-2.5.5
ENDOFFILE
chmod a+x 1434333557766.sh
sudo ./1434333557766.sh
sudo rm -rf 1434333557766.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "freetype2-without-hharfbuzz=>`date`" | sudo tee -a $INSTALLED_LIST