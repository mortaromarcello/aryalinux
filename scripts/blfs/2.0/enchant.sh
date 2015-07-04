#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:glib2
#DEP:aspell


cd $SOURCE_DIR

wget -nc http://www.abisource.com/downloads/enchant/1.6.0/enchant-1.6.0.tar.gz
wget -nc ftp://ftp.netbsd.org/pub/pkgsrc/distfiles/enchant-1.6.0.tar.gz


TARBALL=enchant-1.6.0.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998756.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998756.sh
sudo ./1434987998756.sh
sudo rm -rf 1434987998756.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "enchant=>`date`" | sudo tee -a $INSTALLED_LIST