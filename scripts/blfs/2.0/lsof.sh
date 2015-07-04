#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc ftp://sunsite.ualberta.ca/pub/Mirror/lsof/lsof_4.88.tar.bz2


TARBALL=lsof_4.88.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

tar -xf lsof_4.88_src.tar  &&
cd lsof_4.88_src           &&
./Configure -n linux       &&
make

cat > 1434987998769.sh << "ENDOFFILE"
install -v -m755 -o root -g root lsof /usr/bin &&
install -v lsof.8 /usr/share/man/man8
ENDOFFILE
chmod a+x 1434987998769.sh
sudo ./1434987998769.sh
sudo rm -rf 1434987998769.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "lsof=>`date`" | sudo tee -a $INSTALLED_LIST