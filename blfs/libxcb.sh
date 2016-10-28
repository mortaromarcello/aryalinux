#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libxcb package provides anbr3ak interface to the X Window System protocol, which replaces thebr3ak current Xlib interface. Xlib can also use XCB as a transport layer,br3ak allowing software to make requests and receive responses with both.br3ak
#SECTION:x

#REQ:libXau
#REQ:xcb-proto
#REC:libXdmcp
#OPT:doxygen
#OPT:check
#OPT:libxslt


#VER:libxcb:1.12


NAME="libxcb"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxcb/libxcb-1.12.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libxcb/libxcb-1.12.tar.bz2 || wget -nc http://xcb.freedesktop.org/dist/libxcb-1.12.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libxcb/libxcb-1.12.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxcb/libxcb-1.12.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libxcb/libxcb-1.12.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/libxcb-1.12-python3-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/libxcb/libxcb-1.12-python3-1.patch


URL=http://xcb.freedesktop.org/dist/libxcb-1.12.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../libxcb-1.12-python3-1.patch

sed -i "s/pthread-stubs//" configure &&

./configure $XORG_CONFIG      \
            --enable-xinput   \
            --without-doxygen \
            --docdir='${datadir}'/doc/libxcb-1.12 &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
