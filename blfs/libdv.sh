#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The Quasar DV Codec (libdv) is abr3ak software CODEC for DV video, the encoding format used by mostbr3ak digital camcorders. It can be used to copy videos from camcordersbr3ak using a firewire (IEEE 1394) connection.br3ak"
SECTION="multimedia"
VERSION=1.0.0
NAME="libdv"

#OPT:popt
#OPT:sdl
#OPT:xorg-server


wget -nc http://downloads.sourceforge.net/libdv/libdv-1.0.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdv/libdv-1.0.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libdv/libdv-1.0.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libdv/libdv-1.0.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdv/libdv-1.0.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libdv/libdv-1.0.0.tar.gz


URL=http://downloads.sourceforge.net/libdv/libdv-1.0.0.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --disable-xv \
            --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d      /usr/share/doc/libdv-1.0.0 &&
install -v -m644 README* /usr/share/doc/libdv-1.0.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
