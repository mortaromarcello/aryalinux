#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:pcre


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/qpdf/qpdf-5.1.2.tar.gz


TARBALL=qpdf-5.1.2.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/qpdf-5.1.2 &&
make

cat > 1434987998767.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998767.sh
sudo ./1434987998767.sh
sudo rm -rf 1434987998767.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "qpdf=>`date`" | sudo tee -a $INSTALLED_LIST