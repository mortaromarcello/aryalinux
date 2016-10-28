#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The reiserfsprogs package containsbr3ak various utilities for use with the Reiser file system.br3ak
#SECTION:postlfs



#VER:reiserfsprogs:3.6.25


NAME="reiserfs"

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/reiserfsprogs/reiserfsprogs-3.6.25.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/reiserfsprogs/reiserfsprogs-3.6.25.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/reiserfsprogs/reiserfsprogs-3.6.25.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/reiserfsprogs/reiserfsprogs-3.6.25.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/reiserfsprogs/reiserfsprogs-3.6.25.tar.xz || wget -nc https://www.kernel.org/pub/linux/kernel/people/jeffm/reiserfsprogs/v3.6.25/reiserfsprogs-3.6.25.tar.xz


URL=https://www.kernel.org/pub/linux/kernel/people/jeffm/reiserfsprogs/v3.6.25/reiserfsprogs-3.6.25.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

CFLAGS="$CFLAGS -std=gnu89" \
./configure --prefix=/usr   \
            --sbindir=/sbin &&

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
