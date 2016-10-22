#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

URL=https://github.com/OpenImageIO/oiio/archive/release.zip

cd $SOURCE_DIR

wget -nc $URL

unzip release.zip
cd oiio-release

mkdir -pv build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make
sudo make install

cd $SOURCE_DIR
rm -rf oiio-release

echo "openimageio=>`date`" | sudo tee -a $INSTALLED_LIST
