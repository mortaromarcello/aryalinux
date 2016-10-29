#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:startup-notification
#REQ:python-modules#py2cairo
#REQ:python-modules#pygobject2
#REQ:git
#REQ:pyrex

cd $SOURCE_DIR

git clone https://github.com/noodlylight/fusilli.git
cd fusilli
./autogen.sh --prefix=/usr --disable-marco &&
make -j4
sudo make install

cd $SOURCE_DIR

rm -rf fusilli

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
