#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Cairomm package provides a C++br3ak interface to Cairo.br3ak
#SECTION:x

#REQ:cairo
#REQ:libsigc
#OPT:boost
#OPT:doxygen


#VER:cairomm:1.12.0


NAME="cairomm"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cairo/cairomm-1.12.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cairo/cairomm-1.12.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cairo/cairomm-1.12.0.tar.gz || wget -nc http://cairographics.org/releases/cairomm-1.12.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cairo/cairomm-1.12.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cairo/cairomm-1.12.0.tar.gz


URL=http://cairographics.org/releases/cairomm-1.12.0.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

sed -e '/^libdocdir =/ s/$(book_name)/cairomm-1.12.0/' \
    -i docs/Makefile.in

./configure --prefix=/usr &&
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
