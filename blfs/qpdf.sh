#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Qpdf package containsbr3ak command-line programs and library that do structural,br3ak content-preserving transformations on PDF files.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:pcre
#OPT:fop
#OPT:libxslt


#VER:qpdf:6.0.0


NAME="qpdf"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/qpdf/qpdf-6.0.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/qpdf/qpdf-6.0.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/qpdf/qpdf-6.0.0.tar.gz || wget -nc http://downloads.sourceforge.net/qpdf/qpdf-6.0.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/qpdf/qpdf-6.0.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/qpdf/qpdf-6.0.0.tar.gz


URL=http://downloads.sourceforge.net/qpdf/qpdf-6.0.0.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/qpdf-6.0.0 &&
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
