#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc https://download.samba.org/pub/linux-cifs/cifs-utils/cifs-utils-6.4.tar.bz2


TARBALL=cifs-utils-6.4.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-pam &&
make

cat > 1434987998781.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "cifsutils=>`date`" | sudo tee -a $INSTALLED_LIST