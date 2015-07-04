#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://ftp.xemacs.org/pub/xemacs/aux/compface-1.5.2.tar.gz


TARBALL=compface-1.5.2.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --mandir=/usr/share/man &&
make

cat > 1434987998768.sh << "ENDOFFILE"
make install &&
install -m755 -v xbm2xface.pl /usr/bin
ENDOFFILE
chmod a+x 1434987998768.sh
sudo ./1434987998768.sh
sudo rm -rf 1434987998768.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "compface=>`date`" | sudo tee -a $INSTALLED_LIST