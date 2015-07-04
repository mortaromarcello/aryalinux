#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libxslt
#DEP:docbook


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/rarian/0.8/rarian-0.8.1.tar.bz2
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/rarian/0.8/rarian-0.8.1.tar.bz2


TARBALL=rarian-0.8.1.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr        \
            --localstatedir=/var \
            --disable-static     &&
make

cat > 1434987998769.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998769.sh
sudo ./1434987998769.sh
sudo rm -rf 1434987998769.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "rarian=>`date`" | sudo tee -a $INSTALLED_LIST