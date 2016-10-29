#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="jack"
VERSION="1.9.10"

cd $SOURCE_DIR

URL=https://dl.dropboxusercontent.com/u/28869550/jack-1.9.10.tar.bz2
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

CXXFLAGS="-Wno-narrowing" ./waf configure --prefix=/usr &&
./waf build
sudo ./waf install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
