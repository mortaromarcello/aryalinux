#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Libraw is a library for readingbr3ak RAW files obtained from digital photo cameras (CRW/CR2, NEF, RAF,br3ak DNG, and others).br3ak
#SECTION:general

#REC:libjpeg
#REC:jasper
#REC:lcms2


#VER:LibRaw:0.17.2


NAME="libraw"

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/LibRaw/LibRaw-0.17.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/LibRaw/LibRaw-0.17.2.tar.gz || wget -nc http://www.libraw.org/data/LibRaw-0.17.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/LibRaw/LibRaw-0.17.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/LibRaw/LibRaw-0.17.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/LibRaw/LibRaw-0.17.2.tar.gz


URL=http://www.libraw.org/data/LibRaw-0.17.2.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

CXX="g++ -Wno-narrowing"     \
./configure --prefix=/usr    \
            --enable-jpeg    \
            --enable-jasper  \
            --enable-lcms    \
            --disable-static \
            --docdir=/usr/share/doc/libraw-0.17.2 &&
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
