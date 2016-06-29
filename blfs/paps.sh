#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:paps:0.6.8

#REQ:pango
#OPT:doxygen


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/paps/paps-0.6.8.tar.gz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/paps/paps-0.6.8.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/paps/paps-0.6.8.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/paps/paps-0.6.8.tar.gz || wget -nc http://downloads.sourceforge.net/paps/paps-0.6.8.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/paps/paps-0.6.8.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/paps/paps-0.6.8.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --mandir=/usr/share/man &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d                 /usr/share/doc/paps-0.6.8 &&
install -v -m644 doxygen-doc/html/* /usr/share/doc/paps-0.6.8

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "paps=>`date`" | sudo tee -a $INSTALLED_LIST

