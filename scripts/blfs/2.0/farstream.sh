#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gst10-plugins-base
#DEP:libnice
#DEP:gobject-introspection
#DEP:gst10-plugins-bad
#DEP:gst10-plugins-good


cd $SOURCE_DIR

wget -nc http://freedesktop.org/software/farstream/releases/farstream/farstream-0.2.7.tar.gz


TARBALL=farstream-0.2.7.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998832.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998832.sh
sudo ./1434987998832.sh
sudo rm -rf 1434987998832.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "farstream=>`date`" | sudo tee -a $INSTALLED_LIST