#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://mama.indstate.edu/users/ice/tree/src/tree-1.7.0.tgz
wget -nc ftp://mama.indstate.edu/linux/tree/tree-1.7.0.tgz


TARBALL=tree-1.7.0.tgz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

make

cat > 1434987998770.sh << "ENDOFFILE"
make MANDIR=/usr/share/man/man1 install &&
chmod -v 644 /usr/share/man/man1/tree.1
ENDOFFILE
chmod a+x 1434987998770.sh
sudo ./1434987998770.sh
sudo rm -rf 1434987998770.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "tree=>`date`" | sudo tee -a $INSTALLED_LIST