#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

cd $SOURCE_DIR

git clone https://github.com/dreamworksanimation/openvdb
cd openvdb

cd openvdb
make "-j`nproc`"
sudo make INSTALL_DIR=/usr install

cd $SOURCE_DIR
rm -rf openvdb

echo "openvdb=>`date`" | sudo tee -a $INSTALLED_LIST
