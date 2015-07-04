#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:glib2
#DEP:icu
#DEP:freetype2-without-harfbuzz


cd $SOURCE_DIR

wget -nc http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.38.tar.bz2


TARBALL=harfbuzz-0.9.38.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --with-gobject &&
make

cat > 1434987998765.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998765.sh
sudo ./1434987998765.sh
sudo rm -rf 1434987998765.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "harfbuzz=>`date`" | sudo tee -a $INSTALLED_LIST