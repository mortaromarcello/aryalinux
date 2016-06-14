#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:startup-notification
#REQ:python-modules#py2cairo
#REQ:python-modules#pygobject2
#REQ:git
#REQ:pyrex

cd $SOURCE_DIR

git clone https://github.com/noodlylight/fusilli.git
cd fusilli
./autogen.sh --prefix=/usr &&
make -j4
sudo make install

cd $SOURCE_DIR

rm -rf fusilli

echo "fusilli=>`date`" | sudo tee -a $INSTALLED_LIST
