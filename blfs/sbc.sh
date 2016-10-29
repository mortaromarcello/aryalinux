#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The SBC is a digital audio encoderbr3ak and decoder used to transfer data to Bluetooth audio output devicesbr3ak like headphones or loudspeakers.br3ak"
SECTION="multimedia"
VERSION=1.3
NAME="sbc"

#OPT:libsndfile


wget -nc http://www.kernel.org/pub/linux/bluetooth/sbc-1.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sbc/sbc-1.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sbc/sbc-1.3.tar.xz || wget -nc ftp://www.kernel.org/pub/linux/bluetooth/sbc-1.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sbc/sbc-1.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sbc/sbc-1.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sbc/sbc-1.3.tar.xz


URL=http://www.kernel.org/pub/linux/bluetooth/sbc-1.3.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static --disable-tester &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
