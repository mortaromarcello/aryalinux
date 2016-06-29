#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libevdev:1.5.1

#REQ:python2
#REQ:python3
#OPT:check
#OPT:doxygen
#OPT:valgrind


cd $SOURCE_DIR

URL=http://www.freedesktop.org/software/libevdev/libevdev-1.5.1.tar.xz

wget -nc http://www.freedesktop.org/software/libevdev/libevdev-1.5.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libevdev=>`date`" | sudo tee -a $INSTALLED_LIST

