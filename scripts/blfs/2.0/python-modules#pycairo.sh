#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cairo
#DEP:python3


cd $SOURCE_DIR

wget -nc http://cairographics.org/releases/pycairo-1.10.0.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/pycairo-1.10.0-waf_unpack-1.patch
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/pycairo-1.10.0-waf_python_3_4-1.patch


TARBALL=pycairo-1.10.0.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "python-modules#pycairo=>`date`" | sudo tee -a $INSTALLED_LIST