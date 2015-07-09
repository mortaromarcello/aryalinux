#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:alsa-utils
#DEP:gtk2


cd $SOURCE_DIR

wget -nc https://github.com/downloads/nicklan/pnmixer/pnmixer-0.5.1.tar.gz
wget -nc 


TARBALL=pnmixer-0.5.1.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./autogen.sh --prefix=/usr &&
make

cat > 1434987998839.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998839.sh
sudo ./1434987998839.sh
sudo rm -rf 1434987998839.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "pnmixer=>`date`" | sudo tee -a $INSTALLED_LIST