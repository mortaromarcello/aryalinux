#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="yajl"
VERSION="svn"

cd $SOURCE_DIR

git clone git://github.com/lloyd/yajl
cd yajl

cmake -DCMAKE_INSTALL_PREFIX=/usr &&
make "-j`nproc`" yajl
sudo make install

cd $SOURCE_DIR

rm -rf yajl

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
