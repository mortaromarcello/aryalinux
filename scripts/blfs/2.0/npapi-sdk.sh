#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc https://bitbucket.org/mgorny/npapi-sdk/downloads/npapi-sdk-0.27.2.tar.bz2


TARBALL=npapi-sdk-0.27.2.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr

cat > 1434987998776.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998776.sh
sudo ./1434987998776.sh
sudo rm -rf 1434987998776.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "npapi-sdk=>`date`" | sudo tee -a $INSTALLED_LIST