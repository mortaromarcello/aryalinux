#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:debtargz:2
#VER:rpmtargz:2



cd $SOURCE_DIR

URL=http://downloads.linuxfromscratch.org/deb2targz.tar.bz2

wget -nc http://downloads.linuxfromscratch.org/deb2targz.tar.bz2
wget -nc http://downloads.linuxfromscratch.org/rpm2targz.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "beyond=>`date`" | sudo tee -a $INSTALLED_LIST

