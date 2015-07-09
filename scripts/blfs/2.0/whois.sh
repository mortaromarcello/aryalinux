#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://ftp.debian.org/debian/pool/main/w/whois/whois_5.2.4.tar.xz
wget -nc ftp://ftp.debian.org/debian/pool/main/w/whois/whois_5.2.4.tar.xz


TARBALL=whois_5.2.4.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

make

cat > 1434987998783.sh << "ENDOFFILE"
make prefix=/usr install-whois
make prefix=/usr install-mkpasswd
make prefix=/usr install-pos
ENDOFFILE
chmod a+x 1434987998783.sh
sudo ./1434987998783.sh
sudo rm -rf 1434987998783.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "whois=>`date`" | sudo tee -a $INSTALLED_LIST