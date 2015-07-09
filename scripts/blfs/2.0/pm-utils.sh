#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://pm-utils.freedesktop.org/releases/pm-utils-1.4.1.tar.gz


TARBALL=pm-utils-1.4.1.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/pm-utils-1.4.1 &&
make

cat > 1434987998772.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998772.sh
sudo ./1434987998772.sh
sudo rm -rf 1434987998772.sh

cat > 1434987998772.sh << "ENDOFFILE"
install -v -m644 man/*.1 /usr/share/man/man1 &&
install -v -m644 man/*.8 /usr/share/man/man8 &&
ln -sfv pm-action.8 /usr/share/man/man8/pm-suspend.8 &&
ln -sfv pm-action.8 /usr/share/man/man8/pm-hibernate.8 &&
ln -sfv pm-action.8 /usr/share/man/man8/pm-suspend-hybrid.8
ENDOFFILE
chmod a+x 1434987998772.sh
sudo ./1434987998772.sh
sudo rm -rf 1434987998772.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "pm-utils=>`date`" | sudo tee -a $INSTALLED_LIST