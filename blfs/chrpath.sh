#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The chrpath modify the dynamicbr3ak library load path (rpath and runpath) of compiled programs andbr3ak libraries.br3ak"
SECTION="general"
VERSION=0.16
NAME="chrpath"



wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/chrpath/chrpath-0.16.tar.gz || wget -nc https://alioth.debian.org/frs/download.php/latestfile/813/chrpath-0.16.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/chrpath/chrpath-0.16.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/chrpath/chrpath-0.16.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/chrpath/chrpath-0.16.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/chrpath/chrpath-0.16.tar.gz


URL=https://alioth.debian.org/frs/download.php/latestfile/813/chrpath-0.16.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/chrpath-0.16 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
