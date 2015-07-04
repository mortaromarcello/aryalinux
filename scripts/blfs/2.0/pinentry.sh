#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc ftp://ftp.gnupg.org/gcrypt/pinentry/pinentry-0.9.0.tar.bz2


TARBALL=pinentry-0.9.0.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i 's:../../../s/pinentry/qt4/::' qt4/*.moc &&
./configure --prefix=/usr &&
make

cat > 1434987998769.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998769.sh
sudo ./1434987998769.sh
sudo rm -rf 1434987998769.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "pinentry=>`date`" | sudo tee -a $INSTALLED_LIST