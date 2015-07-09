#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://perso.wanadoo.fr/sebastien.godard/sysstat-11.1.3.tar.xz


TARBALL=sysstat-11.1.3.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sa_lib_dir=/usr/lib/sa    \
sa_dir=/var/log/sa        \
conf_dir=/etc/sysconfig   \
./configure --prefix=/usr \
            --disable-file-attr &&
make

cat > 1434987998773.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998773.sh
sudo ./1434987998773.sh
sudo rm -rf 1434987998773.sh

cat > 1434987998773.sh << "ENDOFFILE"
install -v -m644 sysstat.service /lib/systemd/system/sysstat.service
ENDOFFILE
chmod a+x 1434987998773.sh
sudo ./1434987998773.sh
sudo rm -rf 1434987998773.sh

cat > 1434987998773.sh << "ENDOFFILE"
systemctl enable sysstat
ENDOFFILE
chmod a+x 1434987998773.sh
sudo ./1434987998773.sh
sudo rm -rf 1434987998773.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "sysstat=>`date`" | sudo tee -a $INSTALLED_LIST