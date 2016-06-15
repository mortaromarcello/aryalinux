#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:nettle:3.2

#OPT:openssl


cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/nettle/nettle-3.2.tar.gz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nettle/nettle-3.2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nettle/nettle-3.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nettle/nettle-3.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nettle/nettle-3.2.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/nettle/nettle-3.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nettle/nettle-3.2.tar.gz || wget -nc https://ftp.gnu.org/gnu/nettle/nettle-3.2.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chmod   -v   755 /usr/lib/lib{hogweed,nettle}.so &&
install -v -m755 -d /usr/share/doc/nettle-3.2 &&
install -v -m644 nettle.html /usr/share/doc/nettle-3.2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "nettle=>`date`" | sudo tee -a $INSTALLED_LIST

