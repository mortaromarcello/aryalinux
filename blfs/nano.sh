#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:nano:2.5.3

#OPT:slang


cd $SOURCE_DIR

URL=http://ftp.gnu.org/gnu/nano/nano-2.5.3.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nano/nano-2.5.3.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/nano/nano-2.5.3.tar.gz || wget -nc http://ftp.gnu.org/gnu/nano/nano-2.5.3.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nano/nano-2.5.3.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nano/nano-2.5.3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nano/nano-2.5.3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nano/nano-2.5.3.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-utf8     \
            --docdir=/usr/share/doc/nano-2.5.3 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m644 doc/nanorc.sample /etc &&
install -v -m644 doc/texinfo/nano.html /usr/share/doc/nano-2.5.3

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "nano=>`date`" | sudo tee -a $INSTALLED_LIST

