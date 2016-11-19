#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="A very simple task manager for XFCE"
NAME="xfce4-taskmanager"
VERSION="1.0.0"

URL="http://archive.xfce.org/src/apps/xfce4-taskmanager/1.1/xfce4-taskmanager-1.1.0.tar.bz2"

cd $SOURCE_DIR
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
