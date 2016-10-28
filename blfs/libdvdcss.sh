#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak libdvdcss is a simple librarybr3ak designed for accessing DVDs as a block device without having tobr3ak bother about the decryption.br3ak
#SECTION:multimedia

#OPT:doxygen


#VER:libdvdcss:1.4.0


NAME="libdvdcss"

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libdv/libdvdcss-1.4.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdv/libdvdcss-1.4.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libdv/libdvdcss-1.4.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libdv/libdvdcss-1.4.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdv/libdvdcss-1.4.0.tar.bz2 || wget -nc http://download.videolan.org/libdvdcss/1.4.0/libdvdcss-1.4.0.tar.bz2


URL=http://download.videolan.org/libdvdcss/1.4.0/libdvdcss-1.4.0.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libdvdcss-1.4.0 &&
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
