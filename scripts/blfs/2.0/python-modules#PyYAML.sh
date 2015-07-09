#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:python2
#DEP:python3
#DEP:yaml


cd $SOURCE_DIR

wget -nc http://pyyaml.org/download/pyyaml/PyYAML-3.11.tar.gz


TARBALL=PyYAML-3.11.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "python-modules#PyYAML=>`date`" | sudo tee -a $INSTALLED_LIST