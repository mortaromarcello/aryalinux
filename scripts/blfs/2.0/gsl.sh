#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://ftp.gnu.org/pub/gnu/gsl/gsl-1.16.tar.gz
wget -nc ftp://ftp.gnu.org/pub/gnu/gsl/gsl-1.16.tar.gz


TARBALL=gsl-1.16.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make                                       &&
make html

cat > 1434987998757.sh << "ENDOFFILE"
make install                  &&
mkdir /usr/share/doc/gsl-1.16 &&
cp doc/gsl-ref.html/* /usr/share/doc/gsl-1.16
ENDOFFILE
chmod a+x 1434987998757.sh
sudo ./1434987998757.sh
sudo rm -rf 1434987998757.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gsl=>`date`" | sudo tee -a $INSTALLED_LIST