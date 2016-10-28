#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak libdvdread is a library whichbr3ak provides a simple foundation for reading DVDs.br3ak
#SECTION:multimedia



#VER:libdvdread:5.0.3


NAME="libdvdread"

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdv/libdvdread-5.0.3.tar.bz2 || wget -nc http://download.videolan.org/videolan/libdvdread/5.0.3/libdvdread-5.0.3.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libdv/libdvdread-5.0.3.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libdv/libdvdread-5.0.3.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdv/libdvdread-5.0.3.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libdv/libdvdread-5.0.3.tar.bz2


URL=http://download.videolan.org/videolan/libdvdread/5.0.3/libdvdread-5.0.3.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libdvdread-5.0.3 &&
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
