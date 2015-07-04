#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://jfs.sourceforge.net/project/pub/jfsutils-1.1.15.tar.gz


TARBALL=jfsutils-1.1.15.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed "s@<unistd.h>@&\n#include <sys/types.h>@g" -i fscklog/extract.c &&
./configure &&
make

cat > 1434987998751.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998751.sh
sudo ./1434987998751.sh
sudo rm -rf 1434987998751.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "jfsutils=>`date`" | sudo tee -a $INSTALLED_LIST