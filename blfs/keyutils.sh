#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Keyutils is a set of utilities for managing the key retentionbr3ak facility in the kernel, which can be used by filesystems, blockbr3ak devices and more to gain and retain the authorization andbr3ak encryption keys required to perform secure operations.br3ak
#SECTION:general



#VER:keyutils:1.5.9


NAME="keyutils"

wget -nc http://people.redhat.com/~dhowells/keyutils/keyutils-1.5.9.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/keyutils/keyutils-1.5.9.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/keyutils/keyutils-1.5.9.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/keyutils/keyutils-1.5.9.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/keyutils/keyutils-1.5.9.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/keyutils/keyutils-1.5.9.tar.bz2


URL=http://people.redhat.com/~dhowells/keyutils/keyutils-1.5.9.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make NO_ARLIB=1 install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
