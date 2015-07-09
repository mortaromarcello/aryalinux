#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:dbus-glib
#DEP:python2
#DEP:python3


cd $SOURCE_DIR

wget -nc http://dbus.freedesktop.org/releases/dbus-python/dbus-python-1.2.0.tar.gz


TARBALL=dbus-python-1.2.0.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "python-modules#dbus-python=>`date`" | sudo tee -a $INSTALLED_LIST