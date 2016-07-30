#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:libvdpau:1.1.1

#REQ:x7lib
#OPT:doxygen
#OPT:graphviz
#OPT:texlive
#OPT:tl-installer
#OPT:mesa


cd $SOURCE_DIR

URL=http://people.freedesktop.org/~aplattner/vdpau/libvdpau-1.1.1.tar.bz2

wget -nc http://people.freedesktop.org/~aplattner/vdpau/libvdpau-1.1.1.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG \
            --docdir=/usr/share/doc/libvdpau-1.1.1 &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

echo "libvdpau=>`date`" | sudo tee -a $INSTALLED_LIST
