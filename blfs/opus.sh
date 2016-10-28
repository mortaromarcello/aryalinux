#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Opus is a lossy audio compressionbr3ak format developed by the Internet Engineering Task Force (IETF) thatbr3ak is particularly suitable for interactive speech and audiobr3ak transmission over the Internet. This package provides the Opusbr3ak development library and headers.br3ak
#SECTION:multimedia

#OPT:doxygen
#OPT:texlive
#OPT:tl-installer


#VER:opus:1.1.3


NAME="opus"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/opus/opus-1.1.3.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/opus/opus-1.1.3.tar.gz || wget -nc http://downloads.xiph.org/releases/opus/opus-1.1.3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/opus/opus-1.1.3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/opus/opus-1.1.3.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/opus/opus-1.1.3.tar.gz


URL=http://downloads.xiph.org/releases/opus/opus-1.1.3.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/opus-1.1.3 &&
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
