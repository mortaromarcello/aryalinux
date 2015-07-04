#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:python-modules#pygobject3
#DEP:at-spi2-core


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/pyatspi/2.14/pyatspi-2.14.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/pyatspi/2.14/pyatspi-2.14.0.tar.xz


TARBALL=pyatspi-2.14.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "python-modules#pyatspi2=>`date`" | sudo tee -a $INSTALLED_LIST