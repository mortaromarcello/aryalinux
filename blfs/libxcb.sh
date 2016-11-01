#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The libxcb package provides anbr3ak interface to the X Window System protocol, which replaces thebr3ak current Xlib interface. Xlib can also use XCB as a transport layer,br3ak allowing software to make requests and receive responses with both.br3ak"
SECTION="x"
VERSION=1.12
NAME="libxcb"

#REQ:libXau
#REQ:xcb-proto
#REC:libXdmcp
#OPT:doxygen
#OPT:check
#OPT:libxslt


cd $SOURCE_DIR

URL=http://xcb.freedesktop.org/dist/libxcb-1.12.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxcb/libxcb-1.12.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libxcb/libxcb-1.12.tar.bz2 || wget -nc http://xcb.freedesktop.org/dist/libxcb-1.12.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libxcb/libxcb-1.12.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxcb/libxcb-1.12.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libxcb/libxcb-1.12.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/libxcb-1.12-python3-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/libxcb/libxcb-1.12-python3-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

patch -Np1 -i ../libxcb-1.12-python3-1.patch


sed -i "s/pthread-stubs//" configure &&
./configure $XORG_CONFIG      \
            --enable-xinput   \
            --without-doxygen \
            --docdir='${datadir}'/doc/libxcb-1.12 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
