#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak libtasn1 is a highly portable Cbr3ak library that encodes and decodes DER/BER data following an ASN.1br3ak schema.br3ak
#SECTION:general

whoami > /tmp/currentuser

#OPT:gtk-doc
#OPT:valgrind


#VER:libtasn1:4.9


NAME="libtasn1"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libtasn/libtasn1-4.9.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libtasn/libtasn1-4.9.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libtasn/libtasn1-4.9.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/libtasn1/libtasn1-4.9.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libtasn/libtasn1-4.9.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libtasn/libtasn1-4.9.tar.gz || wget -nc http://ftp.gnu.org/gnu/libtasn1/libtasn1-4.9.tar.gz


URL=http://ftp.gnu.org/gnu/libtasn1/libtasn1-4.9.tar.gz
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



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C doc/reference install-data-local

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
