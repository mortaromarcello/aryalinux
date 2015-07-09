#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://fribidi.org/download/fribidi-0.19.6.tar.bz2


TARBALL=fribidi-0.19.6.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i "s|glib/gstrfuncs\.h|glib.h|" charset/fribidi-char-sets.c &&
sed -i "s|glib/gmem\.h|glib.h|"      lib/mem.h                   &&
./configure --prefix=/usr                                        &&
make

cat > 1434987998765.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998765.sh
sudo ./1434987998765.sh
sudo rm -rf 1434987998765.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "fribidi=>`date`" | sudo tee -a $INSTALLED_LIST