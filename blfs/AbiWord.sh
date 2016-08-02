#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:abiword-docs:3.0.1
#VER:abiword:3.0.1

#REQ:boost
#REQ:fribidi
#REQ:goffice010
#REQ:wv
#REC:enchant
#OPT:dbus-glib
#OPT:gobject-introspection
#OPT:libgcrypt
#OPT:libical
#OPT:libsoup
#OPT:redland
#OPT:valgrind


cd $SOURCE_DIR

URL=http://www.abisource.com/downloads/abiword/3.0.1/source/abiword-3.0.1.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/abiword/abiword-docs-3.0.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/abiword/abiword-docs-3.0.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/abiword/abiword-docs-3.0.1.tar.gz || wget -nc http://www.abisource.com/downloads/abiword/3.0.1/source/abiword-docs-3.0.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/abiword/abiword-docs-3.0.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/abiword/abiword-docs-3.0.1.tar.gz
wget -nc http://www.abisource.com/downloads/abiword/3.0.1/source/abiword-3.0.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/abiword/abiword-3.0.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/abiword/abiword-3.0.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/abiword/abiword-3.0.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/abiword/abiword-3.0.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/abiword/abiword-3.0.1.tar.gz

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


tar -xf ../abiword-docs-3.0.1.tar.gz &&
cd abiword-docs-3.0.1                &&
./configure --prefix=/usr            &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


ls /usr/share/abiword-3.0/templates


install -v -m750 -d ~/.AbiSuite/templates &&
install -v -m640    /usr/share/abiword-3.0/templates/normal.awt-<em class="replaceable"><code><lang></em> \
                    ~/.AbiSuite/templates/normal.awt


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "AbiWord=>`date`" | sudo tee -a $INSTALLED_LIST

