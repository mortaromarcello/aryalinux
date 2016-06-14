#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:xmlto:0.0.28

#REQ:docbook
#REQ:docbook-xsl
#REQ:libxslt
#OPT:fop
#OPT:links
#OPT:lynx
#OPT:w3m


cd $SOURCE_DIR

URL=https://fedorahosted.org/releases/x/m/xmlto/xmlto-0.0.28.tar.bz2

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xmlto/xmlto-0.0.28.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xmlto/xmlto-0.0.28.tar.bz2 || wget -nc https://fedorahosted.org/releases/x/m/xmlto/xmlto-0.0.28.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xmlto/xmlto-0.0.28.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xmlto/xmlto-0.0.28.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xmlto/xmlto-0.0.28.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

LINKS="/usr/bin/links" \
./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "xmlto=>`date`" | sudo tee -a $INSTALLED_LIST

