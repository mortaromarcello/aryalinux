#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak libjpeg-turbo is a fork of thebr3ak original IJG libjpeg which usesbr3ak SIMD to accelerate baseline JPEG compression and decompression.br3ak libjpeg is a library thatbr3ak implements JPEG image encoding, decoding and transcoding.br3ak
#SECTION:general

#REQ:nasm
#REQ:yasm


#VER:libjpeg-turbo:1.5.1


NAME="libjpeg"

wget -nc http://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-1.5.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libjpeg-turbo/libjpeg-turbo-1.5.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libjpeg-turbo/libjpeg-turbo-1.5.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libjpeg-turbo/libjpeg-turbo-1.5.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libjpeg-turbo/libjpeg-turbo-1.5.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libjpeg-turbo/libjpeg-turbo-1.5.1.tar.gz


URL=http://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-1.5.1.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-jpeg8            \
            --disable-static        \
            --docdir=/usr/share/doc/libjpeg-turbo-1.5.1 &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
rm -f /usr/lib/libjpeg.so*
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
