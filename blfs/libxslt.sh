#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libxslt package contains XSLTbr3ak libraries used for extending <code class="filename">libxml2br3ak libraries to support XSLT files.br3ak
#SECTION:general

#REQ:libxml2
#REC:docbook
#REC:docbook-xsl
#OPT:libgcrypt
#OPT:python2


#VER:libxslt:1.1.29


NAME="libxslt"

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libxslt/libxslt-1.1.29.tar.gz || wget -nc http://xmlsoft.org/sources/libxslt-1.1.29.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxslt/libxslt-1.1.29.tar.gz || wget -nc ftp://xmlsoft.org/libxslt/libxslt-1.1.29.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libxslt/libxslt-1.1.29.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libxslt/libxslt-1.1.29.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxslt/libxslt-1.1.29.tar.gz


URL=http://xmlsoft.org/sources/libxslt-1.1.29.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

sed -i "/seems to be moved/s/^/#/" ltmain.sh &&
./configure --prefix=/usr --disable-static &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
