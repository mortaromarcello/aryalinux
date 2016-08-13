#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:aalib-1.4rc:5

#OPT:slang
#OPT:gpm
#OPT:xorg-server


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/aa-project/aalib-1.4rc5.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/aalib/aalib-1.4rc5.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/aalib/aalib-1.4rc5.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/aalib/aalib-1.4rc5.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/aalib/aalib-1.4rc5.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/aalib/aalib-1.4rc5.tar.gz || wget -nc http://downloads.sourceforge.net/aa-project/aalib-1.4rc5.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i -e '/AM_PATH_AALIB,/s/AM_PATH_AALIB/[&]/' aalib.m4


./configure --prefix=/usr             \
            --infodir=/usr/share/info \
            --mandir=/usr/share/man   \
            --disable-static          &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "aalib=>`date`" | sudo tee -a $INSTALLED_LIST

