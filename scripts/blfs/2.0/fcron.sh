#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://fcron.free.fr/archives/fcron-3.2.0.src.tar.gz


TARBALL=fcron-3.2.0.src.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998771.sh << "ENDOFFILE"
groupadd -g 22 fcron &&
useradd -d /dev/null -c "Fcron User" -g fcron -s /bin/false -u 22 fcron
ENDOFFILE
chmod a+x 1434987998771.sh
sudo ./1434987998771.sh
sudo rm -rf 1434987998771.sh

./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --localstatedir=/var   \
            --without-sendmail     \
            --without-boot-install &&
make

cat > 1434987998771.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998771.sh
sudo ./1434987998771.sh
sudo rm -rf 1434987998771.sh

cat > 1434987998771.sh << "ENDOFFILE"
systemctl enable fcron
ENDOFFILE
chmod a+x 1434987998771.sh
sudo ./1434987998771.sh
sudo rm -rf 1434987998771.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "fcron=>`date`" | sudo tee -a $INSTALLED_LIST