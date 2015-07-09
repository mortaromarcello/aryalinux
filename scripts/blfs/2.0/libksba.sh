#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libgpg-error


cd $SOURCE_DIR

wget -nc ftp://ftp.gnupg.org/gcrypt/libksba/libksba-1.3.2.tar.bz2


TARBALL=libksba-1.3.2.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998761.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998761.sh
sudo ./1434987998761.sh
sudo rm -rf 1434987998761.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libksba=>`date`" | sudo tee -a $INSTALLED_LIST