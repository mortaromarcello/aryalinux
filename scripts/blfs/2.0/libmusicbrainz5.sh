#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cmake
#DEP:libxml2
#DEP:neon


cd $SOURCE_DIR

wget -nc https://github.com/metabrainz/libmusicbrainz/releases/download/release-5.1.0/libmusicbrainz-5.1.0.tar.gz


TARBALL=libmusicbrainz-5.1.0.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr .. &&
make

cat > 1434987998835.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998835.sh
sudo ./1434987998835.sh
sudo rm -rf 1434987998835.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libmusicbrainz5=>`date`" | sudo tee -a $INSTALLED_LIST