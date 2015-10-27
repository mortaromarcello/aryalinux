#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:docbook
#DEP:docbook-xsl
#DEP:libxml2
#DEP:python2


cd $SOURCE_DIR

wget -nc http://files.itstool.org/itstool/itstool-2.0.2.tar.bz2


TARBALL=itstool-2.0.2.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998842.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998842.sh
sudo ./1434987998842.sh
sudo rm -rf 1434987998842.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "itstool=>`date`" | sudo tee -a $INSTALLED_LIST