#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak ldns is a fast DNS library withbr3ak the goal to simplify DNS programming and to allow developers tobr3ak easily create software conforming to current RFCs and Internetbr3ak drafts. This packages also includes the <span class="command"><strong>drill</strong> tool.br3ak"
SECTION="basicnet"
VERSION=1.6.17
NAME="ldns"

#REC:openssl
#OPT:cacerts
#OPT:libpcap
#OPT:python2
#OPT:swig
#OPT:doxygen


wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ldns/ldns-1.6.17.tar.gz || wget -nc http://www.nlnetlabs.nl/downloads/ldns/ldns-1.6.17.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ldns/ldns-1.6.17.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ldns/ldns-1.6.17.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ldns/ldns-1.6.17.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ldns/ldns-1.6.17.tar.gz


URL=http://www.nlnetlabs.nl/downloads/ldns/ldns-1.6.17.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i 's/defined(@$also)/@$also/' doc/doxyparse.pl &&
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --with-drill      &&
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
