#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libvdpau:1.1.1

#REQ:x7lib
#OPT:doxygen
#OPT:graphviz
#OPT:texlive
#OPT:tl-installer
#OPT:mesa
#OPT:libvdpau-va-gl


cd $SOURCE_DIR

URL=http://people.freedesktop.org/~aplattner/vdpau/libvdpau-1.1.1.tar.gz

wget -nc http://people.freedesktop.org/~aplattner/vdpau/libvdpau-1.1.1.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libvdpau=>`date`" | sudo tee -a $INSTALLED_LIST

