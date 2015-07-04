#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/libdiscid-0.6.1.tar.gz
wget -nc ftp://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/libdiscid-0.6.1.tar.gz


TARBALL=libdiscid-0.6.1.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998834.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998834.sh
sudo ./1434987998834.sh
sudo rm -rf 1434987998834.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libdiscid=>`date`" | sudo tee -a $INSTALLED_LIST