#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:lxterminal:0.2.0

#REQ:vte2
#OPT:libxslt
#OPT:docbook
#OPT:docbook-xsl


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/lxde/lxterminal-0.2.0.tar.gz

wget -nc http://downloads.sourceforge.net/lxde/lxterminal-0.2.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxterminal/lxterminal-0.2.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxterminal/lxterminal-0.2.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxterminal/lxterminal-0.2.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxterminal/lxterminal-0.2.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxterminal/lxterminal-0.2.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

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
echo "lxterminal=>`date`" | sudo tee -a $INSTALLED_LIST

