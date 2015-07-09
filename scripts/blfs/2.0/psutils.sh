#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://pkgs.fedoraproject.org/repo/pkgs/psutils/psutils-p17.tar.gz/b161522f3bd1507655326afa7db4a0ad/psutils-p17.tar.gz


TARBALL=psutils-p17.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed 's@/usr/local@/usr@g' Makefile.unix > Makefile &&
make

cat > 1434987998843.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998843.sh
sudo ./1434987998843.sh
sudo rm -rf 1434987998843.sh

lp -o number-up=2 <em class="replaceable"><code><filename></em>


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "psutils=>`date`" | sudo tee -a $INSTALLED_LIST