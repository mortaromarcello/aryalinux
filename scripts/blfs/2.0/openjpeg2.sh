#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cmake


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/openjpeg.mirror/openjpeg-2.1.0.tar.gz


TARBALL=openjpeg-2.1.0.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir build &&
cd build    &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      .. &&
make

cat > 1434987998767.sh << "ENDOFFILE"
make install &&
cd ../doc &&
for man in man/man?/*
do
  install -v -Dm644 $man /usr/share/$man
done
ENDOFFILE
chmod a+x 1434987998767.sh
sudo ./1434987998767.sh
sudo rm -rf 1434987998767.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "openjpeg2=>`date`" | sudo tee -a $INSTALLED_LIST