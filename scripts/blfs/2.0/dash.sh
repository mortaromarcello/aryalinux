#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.8.tar.gz


TARBALL=dash-0.5.8.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --bindir=/bin --mandir=/usr/share/man &&
make

cat > 1434987998754.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998754.sh
sudo ./1434987998754.sh
sudo rm -rf 1434987998754.sh

ln -svf dash /bin/sh

cat > 1434987998754.sh << "ENDOFFILE"
cat >> /etc/shells << "EOF"
/bin/dash
EOF
ENDOFFILE
chmod a+x 1434987998754.sh
sudo ./1434987998754.sh
sudo rm -rf 1434987998754.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "dash=>`date`" | sudo tee -a $INSTALLED_LIST