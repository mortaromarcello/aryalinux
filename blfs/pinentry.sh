#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:pinentry:0.9.7

#REQ:libassuan
#REQ:libgpg-error
#OPT:gcr
#OPT:gtk2
#OPT:gtk3
#OPT:libcap
#OPT:libsecret
#OPT:qt4
#OPT:qt5


cd $SOURCE_DIR

URL=ftp://ftp.gnupg.org/gcrypt/pinentry/pinentry-0.9.7.tar.bz2

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pinentry/pinentry-0.9.7.tar.bz2 || wget -nc ftp://ftp.gnupg.org/gcrypt/pinentry/pinentry-0.9.7.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pinentry/pinentry-0.9.7.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pinentry/pinentry-0.9.7.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pinentry/pinentry-0.9.7.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pinentry/pinentry-0.9.7.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-pinentry-qt5 --enable-pinentry-qt=no &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "pinentry=>`date`" | sudo tee -a $INSTALLED_LIST

