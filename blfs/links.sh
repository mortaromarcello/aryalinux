#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:links:2.12

#REC:openssl
#OPT:gpm
#OPT:xorg-server


cd $SOURCE_DIR

URL=http://links.twibright.com/download/links-2.12.tar.bz2

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/links/links-2.12.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/links/links-2.12.tar.bz2 || wget -nc http://links.twibright.com/download/links-2.12.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/links/links-2.12.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/links/links-2.12.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/links/links-2.12.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --mandir=/usr/share/man &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -d -m755 /usr/share/doc/links-2.12 &&
install -v -m644 doc/links_cal/* KEYS BRAILLE_HOWTO \
    /usr/share/doc/links-2.12

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "links=>`date`" | sudo tee -a $INSTALLED_LIST

