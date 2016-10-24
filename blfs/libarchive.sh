#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The libarchive library provides abr3ak single interface for reading/writing various compression formats.br3ak
#SECTION:general

whoami > /tmp/currentuser

#OPT:libxml2
#OPT:lzo
#OPT:nettle
#OPT:openssl


#VER:libarchive:3.2.1


NAME="libarchive"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libarchive/libarchive-3.2.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libarchive/libarchive-3.2.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libarchive/libarchive-3.2.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libarchive/libarchive-3.2.1.tar.gz || wget -nc http://www.libarchive.org/downloads/libarchive-3.2.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libarchive/libarchive-3.2.1.tar.gz


URL=http://www.libarchive.org/downloads/libarchive-3.2.1.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
