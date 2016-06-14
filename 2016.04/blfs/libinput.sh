#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libinput:1.2.1

#REQ:libevdev
#REQ:mtdev
#OPT:check
#OPT:valgrind
#OPT:doxygen
#OPT:graphviz
#OPT:gtk3


cd $SOURCE_DIR

URL=http://www.freedesktop.org/software/libinput/libinput-1.2.1.tar.xz

wget -nc http://www.freedesktop.org/software/libinput/libinput-1.2.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr     \
            --disable-libwacom \
            --with-udev-dir=/lib/udev &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libinput=>`date`" | sudo tee -a $INSTALLED_LIST

