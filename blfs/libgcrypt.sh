#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libgcrypt:1.7.3

#REQ:libgpg-error
#OPT:libcap
#OPT:pth
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.7.3.tar.bz2

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgcrypt/libgcrypt-1.7.3.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libgcrypt/libgcrypt-1.7.3.tar.bz2 || wget -nc ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.7.3.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libgcrypt/libgcrypt-1.7.3.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgcrypt/libgcrypt-1.7.3.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libgcrypt/libgcrypt-1.7.3.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -dm755   /usr/share/doc/libgcrypt-1.7.3 &&
install -v -m644    README doc/{README.apichanges,fips*,libgcrypt*} \
                    /usr/share/doc/libgcrypt-1.7.3

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libgcrypt=>`date`" | sudo tee -a $INSTALLED_LIST

