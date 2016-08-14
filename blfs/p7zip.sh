#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:p7zip_src_all:_16.02



cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/p7zip/p7zip_16.02_src_all.tar.bz2

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/p7zip/p7zip_16.02_src_all.tar.bz2 || wget -nc http://downloads.sourceforge.net/p7zip/p7zip_16.02_src_all.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/p7zip/p7zip_16.02_src_all.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/p7zip/p7zip_16.02_src_all.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/p7zip/p7zip_16.02_src_all.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/p7zip/p7zip_16.02_src_all.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

make all3



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make DEST_HOME=/usr \
     DEST_MAN=/usr/share/man \
     DEST_SHARE_DOC=/usr/share/doc/p7zip-16.02 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "p7zip=>`date`" | sudo tee -a $INSTALLED_LIST

