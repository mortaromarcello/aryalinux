#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The CUPS Filters package containsbr3ak backends, filters and other software that was once part of the corebr3ak CUPS distribution but is no longerbr3ak maintained by Apple Inc.br3ak"
SECTION="pst"
VERSION=1.11.1
NAME="cups-filters"

#REQ:cups
#REQ:glib2
#REQ:ijs
#REQ:lcms2
#REQ:poppler
#REQ:qpdf
#REQ:gs
#REQ:gutenprint
#REC:libjpeg
#REC:libpng
#REC:libtiff
#OPT:avahi
#OPT:openldap
#OPT:php


cd $SOURCE_DIR

URL=https://www.openprinting.org/download/cups-filters/cups-filters-1.11.1.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cups/cups-filters-1.11.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cups/cups-filters-1.11.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cups/cups-filters-1.11.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cups/cups-filters-1.11.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cups/cups-filters-1.11.1.tar.xz || wget -nc https://www.openprinting.org/download/cups-filters/cups-filters-1.11.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser


./configure                             \
        --prefix=/usr                   \
        --sysconfdir=/etc               \
        --localstatedir=/var            \
        --without-rcdir                 \
        --disable-static                \
        --disable-avahi                 \
        --with-gs-path=/usr/bin/gs      \
        --with-pdftops-path=/usr/bin/gs \
        --docdir=/usr/share/doc/cups-filters-1.11.1 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh





if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
