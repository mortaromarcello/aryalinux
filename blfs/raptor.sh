#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Raptor is a C library thatbr3ak provides a set of parsers and serializers that generate Resourcebr3ak Description Framework (RDF) triples.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:curl
#REQ:libxslt
#OPT:gtk-doc
#OPT:icu


#VER:raptor2:2.0.15


NAME="raptor"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/raptor/raptor2-2.0.15.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/raptor/raptor2-2.0.15.tar.gz || wget -nc http://download.librdf.org/source/raptor2-2.0.15.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/raptor/raptor2-2.0.15.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/raptor/raptor2-2.0.15.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/raptor/raptor2-2.0.15.tar.gz


URL=http://download.librdf.org/source/raptor2-2.0.15.tar.gz
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
