#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:qpdf:6.0.0

#REQ:pcre
#OPT:fop
#OPT:libxslt


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/qpdf/qpdf-6.0.0.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/qpdf/qpdf-6.0.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/qpdf/qpdf-6.0.0.tar.gz || wget -nc http://downloads.sourceforge.net/qpdf/qpdf-6.0.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/qpdf/qpdf-6.0.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/qpdf/qpdf-6.0.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/qpdf/qpdf-6.0.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/qpdf-6.0.0 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "qpdf=>`date`" | sudo tee -a $INSTALLED_LIST

