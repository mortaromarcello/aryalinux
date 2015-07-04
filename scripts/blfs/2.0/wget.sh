#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:openssl


cd $SOURCE_DIR

wget -nc http://ftp.gnu.org/gnu/wget/wget-1.16.1.tar.xz
wget -nc ftp://ftp.gnu.org/gnu/wget/wget-1.16.1.tar.xz


TARBALL=wget-1.16.1.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr      \
            --sysconfdir=/etc  \
            --with-ssl=openssl &&
make

cat > 1434987998782.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh

cat > 1434987998782.sh << "ENDOFFILE"
echo ca-directory=/etc/ssl/certs >> /etc/wgetrc
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "wget=>`date`" | sudo tee -a $INSTALLED_LIST