#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:joe:4.2



cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/joe-editor/joe-4.2.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/joe/joe-4.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/joe/joe-4.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/joe/joe-4.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/joe/joe-4.2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/joe/joe-4.2.tar.gz || wget -nc http://downloads.sourceforge.net/joe-editor/joe-4.2.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/joe-4.2 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -vm 755 joe/util/{stringify,termidx,uniproc} /usr/bin &&
install -vdm755 /usr/share/joe/util &&
install -vm 644 joe/util/{*.txt,README} /usr/share/joe/util

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "joe=>`date`" | sudo tee -a $INSTALLED_LIST

