#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:compface:1.5.2



cd $SOURCE_DIR

URL=http://ftp.xemacs.org/pub/xemacs/aux/compface-1.5.2.tar.gz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/compface/compface-1.5.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/compface/compface-1.5.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/compface/compface-1.5.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/compface/compface-1.5.2.tar.gz || wget -nc http://ftp.xemacs.org/pub/xemacs/aux/compface-1.5.2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/compface/compface-1.5.2.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --mandir=/usr/share/man &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -m755 -v xbm2xface.pl /usr/bin

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "compface=>`date`" | sudo tee -a $INSTALLED_LIST

