#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:fusilli

cd $SOURCE_DIR

git clone https://github.com/noodlylight/rotini.git
cd rotini
./autogen.sh --prefix=/usr &&
make -j4
sudo make install

cd $SOURCE_DIR

rm -rf rotini

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
