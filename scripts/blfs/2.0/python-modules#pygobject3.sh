#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gobject-introspection
#DEP:python-modules#py2cairo
#DEP:python-modules#pycairo


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/pygobject/3.14/pygobject-3.14.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/pygobject/3.14/pygobject-3.14.0.tar.xz


TARBALL=pygobject-3.14.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "python-modules#pygobject3=>`date`" | sudo tee -a $INSTALLED_LIST