#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:kdelibs
#DEP:alsa-lib
#DEP:exiv2
#DEP:kactivities
#DEP:kdepimlibs


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/4.14.3/src/kde-runtime-4.14.3.tar.xz


TARBALL=kde-runtime-4.14.3.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX         \
      -DSYSCONF_INSTALL_DIR=/etc                 \
      -DCMAKE_BUILD_TYPE=Release                 \
      -DSAMBA_INCLUDE_DIR=/usr/include/samba-4.0 \
      -Wno-dev .. &&
make

cat > 1434987998799.sh << "ENDOFFILE"
make install &&
ln -sfv ../lib/kde4/libexec/kdesu $KDE_PREFIX/bin/kdesu
ENDOFFILE
chmod a+x 1434987998799.sh
sudo ./1434987998799.sh
sudo rm -rf 1434987998799.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "kde-runtime=>`date`" | sudo tee -a $INSTALLED_LIST