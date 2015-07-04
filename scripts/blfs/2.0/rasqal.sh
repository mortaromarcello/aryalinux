#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:raptor


cd $SOURCE_DIR

wget -nc http://download.librdf.org/source/rasqal-0.9.33.tar.gz


TARBALL=rasqal-0.9.33.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998772.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998772.sh
sudo ./1434987998772.sh
sudo rm -rf 1434987998772.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "rasqal=>`date`" | sudo tee -a $INSTALLED_LIST