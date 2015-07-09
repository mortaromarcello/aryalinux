#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:python-modules#setuptools


cd $SOURCE_DIR

wget -nc https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz


TARBALL=MarkupSafe-0.23.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "python-modules#MarkupSafe=>`date`" | sudo tee -a $INSTALLED_LIST