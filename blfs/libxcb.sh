#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libxcb:1.11.1

#REQ:libXau
#REQ:xcb-proto
#REC:libXdmcp
#OPT:doxygen
#OPT:check
#OPT:libxslt


cd $SOURCE_DIR

URL=http://xcb.freedesktop.org/dist/libxcb-1.11.1.tar.bz2

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libxcb/libxcb-1.11.1.tar.bz2 || wget -nc http://xcb.freedesktop.org/dist/libxcb-1.11.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libxcb/libxcb-1.11.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libxcb/libxcb-1.11.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxcb/libxcb-1.11.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxcb/libxcb-1.11.1.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

sed -i "s/pthread-stubs//" configure &&
./configure $XORG_CONFIG    \
            --enable-xinput \
            --docdir='${datadir}'/doc/libxcb-1.11.1 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libxcb=>`date`" | sudo tee -a $INSTALLED_LIST

