#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak AAlib is a library to render anybr3ak graphic into ASCII Art.br3ak
#SECTION:general

#OPT:installing
#OPT:slang
#OPT:gpm


#VER:aalib-1.4rc:5


NAME="aalib"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/aalib/aalib-1.4rc5.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/aalib/aalib-1.4rc5.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/aalib/aalib-1.4rc5.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/aalib/aalib-1.4rc5.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/aalib/aalib-1.4rc5.tar.gz || wget -nc http://downloads.sourceforge.net/aa-project/aalib-1.4rc5.tar.gz


URL=http://downloads.sourceforge.net/aa-project/aalib-1.4rc5.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

sed -i -e '/AM_PATH_AALIB,/s/AM_PATH_AALIB/[&]/' aalib.m4

./configure --prefix=/usr             \
            --infodir=/usr/share/info \
            --mandir=/usr/share/man   \
            --disable-static          &&
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
