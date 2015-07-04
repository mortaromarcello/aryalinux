#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://www.kernel.org/pub/linux/daemons/autofs/v5/autofs-5.1.0.tar.xz
wget -nc ftp://ftp.kernel.org/pub/linux/daemons/autofs/v5/autofs-5.1.0.tar.xz


TARBALL=autofs-5.1.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i -e '/include.*config.h/ i #include <stdarg.h>' lib/defaults.c &&

./configure --prefix=/         \
            --with-systemd     \
            --without-openldap \
            --mandir=/usr/share/man &&
make

cat > 1434987998770.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998770.sh
sudo ./1434987998770.sh
sudo rm -rf 1434987998770.sh

cat > 1434987998770.sh << "ENDOFFILE"
mv /etc/auto.master /etc/auto.master.bak &&
cat > /etc/auto.master << "EOF"
# Begin /etc/auto.master

/media/auto /etc/auto.misc --ghost
#/home /etc/auto.home

# End /etc/auto.master
EOF
ENDOFFILE
chmod a+x 1434987998770.sh
sudo ./1434987998770.sh
sudo rm -rf 1434987998770.sh

cat > 1434987998770.sh << "ENDOFFILE"
systemctl enable autofs
ENDOFFILE
chmod a+x 1434987998770.sh
sudo ./1434987998770.sh
sudo rm -rf 1434987998770.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "autofs=>`date`" | sudo tee -a $INSTALLED_LIST