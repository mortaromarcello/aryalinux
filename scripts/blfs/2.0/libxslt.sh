#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libxml2
#DEP:docbook
#DEP:docbook-xsl


cd $SOURCE_DIR

wget -nc http://xmlsoft.org/sources/libxslt-1.1.28.tar.gz
wget -nc ftp://xmlsoft.org/libxslt/libxslt-1.1.28.tar.gz


TARBALL=libxslt-1.1.28.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998763.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998763.sh
sudo ./1434987998763.sh
sudo rm -rf 1434987998763.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libxslt=>`date`" | sudo tee -a $INSTALLED_LIST