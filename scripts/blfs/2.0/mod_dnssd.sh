#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:apache
#DEP:avahi


cd $SOURCE_DIR

wget -nc http://0pointer.de/lennart/projects/mod_dnssd/mod_dnssd-0.6.tar.gz


TARBALL=mod_dnssd-0.6.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i 's/unixd_setup_child/ap_&/' src/mod_dnssd.c &&

./configure --prefix=/usr --disable-lynx &&
make

cat > 1434987998783.sh << "ENDOFFILE"
make install
sed -i 's| usr| /usr|' /etc/httpd/httpd.conf
ENDOFFILE
chmod a+x 1434987998783.sh
sudo ./1434987998783.sh
sudo rm -rf 1434987998783.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "mod_dnssd=>`date`" | sudo tee -a $INSTALLED_LIST