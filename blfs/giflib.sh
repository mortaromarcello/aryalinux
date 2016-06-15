#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:giflib:5.1.2

#OPT:xmlto


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/giflib/giflib-5.1.2.tar.bz2

wget -nc http://downloads.sourceforge.net/giflib/giflib-5.1.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/giflib/giflib-5.1.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/giflib/giflib-5.1.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/giflib/giflib-5.1.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/giflib/giflib-5.1.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/giflib/giflib-5.1.2.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
find doc \( -name Makefile\* -o -name \*.1 \
         -o -name \*.xml \) -exec rm -v {} \; &&
install -v -dm755 /usr/share/doc/giflib-5.1.2 &&
cp -v -R doc/* /usr/share/doc/giflib-5.1.2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "giflib=>`date`" | sudo tee -a $INSTALLED_LIST

