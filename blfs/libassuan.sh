#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libassuan:2.4.3

#REQ:libgpg-error
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-2.4.3.tar.bz2

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libassuan/libassuan-2.4.3.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libassuan/libassuan-2.4.3.tar.bz2 || wget -nc ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-2.4.3.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libassuan/libassuan-2.4.3.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libassuan/libassuan-2.4.3.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libassuan/libassuan-2.4.3.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

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
echo "libassuan=>`date`" | sudo tee -a $INSTALLED_LIST

