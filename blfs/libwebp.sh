#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libwebp package contains abr3ak library and support programs to encode and decode images in WebPbr3ak format.br3ak
#SECTION:general

#REC:libjpeg
#REC:libpng
#REC:libtiff
#OPT:freeglut
#OPT:giflib


#VER:libwebp:0.5.1


NAME="libwebp"

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libwebp/libwebp-0.5.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libwebp/libwebp-0.5.1.tar.gz || wget -nc http://downloads.webmproject.org/releases/webp/libwebp-0.5.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libwebp/libwebp-0.5.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libwebp/libwebp-0.5.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libwebp/libwebp-0.5.1.tar.gz


URL=http://downloads.webmproject.org/releases/webp/libwebp-0.5.1.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr           \
            --enable-libwebpmux     \
            --enable-libwebpdemux   \
            --enable-libwebpdecoder \
            --enable-libwebpextras  \
            --enable-swap-16bit-csp \
            --disable-static        &&

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
