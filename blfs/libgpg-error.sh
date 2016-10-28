#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libgpg-error package containsbr3ak a library that defines common error values for all GnuPG components. .br3ak
#SECTION:general



#VER:libgpg-error:1.24


NAME="libgpg-error"

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libgpg-error/libgpg-error-1.24.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgpg-error/libgpg-error-1.24.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libgpg-error/libgpg-error-1.24.tar.bz2 || wget -nc ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.24.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libgpg-error/libgpg-error-1.24.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgpg-error/libgpg-error-1.24.tar.bz2


URL=ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.24.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m644 -D README /usr/share/doc/libgpg-error-1.24/README
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
