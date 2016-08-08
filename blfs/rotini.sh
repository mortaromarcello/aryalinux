#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:fusilli

cd $SOURCE_DIR

git clone https://github.com/noodlylight/rotini.git
cd rotini
./autogen.sh --prefix=/usr &&
make -j4
sudo make install

cd $SOURCE_DIR

rm -rf rotini

echo "rotini=>`date`" | sudo tee -a $INSTALLED_LIST
