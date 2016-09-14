#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

PACKAGE_NAME="ibus-rime"

#REQ:ibus
#REQ:librime
#REQ:brise

URL=http://archive.ubuntu.com/ubuntu/pool/universe/i/ibus-rime/ibus-rime_1.2.orig.tar.gz

cd $SOURCE_DIR
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

sudo ./install.sh

cd $SOURCE_DIR
sudo rm -r $DIRECTORY

echo "$PACKAGE_NAME=>`date`" | sudo tee -a $INSTALLED_LIST
