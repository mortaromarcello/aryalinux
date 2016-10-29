#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak Check is a unit testing frameworkbr3ak for C. It was installed by LFS in the temporary /tools directory.br3ak These instructions install it permanently.br3ak"
SECTION="general"
VERSION=0.10.0
NAME="check"



wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/check/check-0.10.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/check/check-0.10.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/check/check-0.10.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/check/check-0.10.0.tar.gz || wget -nc http://downloads.sourceforge.net/check/check-0.10.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/check/check-0.10.0.tar.gz


URL=http://downloads.sourceforge.net/check/check-0.10.0.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/check-0.10.0 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
