#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak fdk-aac package provides thebr3ak Fraunhofer FDK AAC library, which is purported to be a high qualitybr3ak Advanced Audio Coding implementation.br3ak"
SECTION="multimedia"
VERSION=0.1.4
NAME="fdk-aac"



wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fdk-aac/fdk-aac-0.1.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fdk-aac/fdk-aac-0.1.4.tar.gz || wget -nc http://downloads.sourceforge.net/opencore-amr/fdk-aac-0.1.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fdk-aac/fdk-aac-0.1.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fdk-aac/fdk-aac-0.1.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fdk-aac/fdk-aac-0.1.4.tar.gz


URL=http://downloads.sourceforge.net/opencore-amr/fdk-aac-0.1.4.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

CXX='g++ -Wno-narrowing'     \
./configure --prefix=/usr    \
            --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
