#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libpciaccess:0.13.4



cd $SOURCE_DIR

URL=http://ftp.x.org/pub/individual/lib/libpciaccess-0.13.4.tar.bz2

wget -nc http://ftp.x.org/pub/individual/lib/libpciaccess-0.13.4.tar.bz2 || wget -nc ftp://ftp.x.org/pub/individual/lib/libpciaccess-0.13.4.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libpciaccess=>`date`" | sudo tee -a $INSTALLED_LIST

