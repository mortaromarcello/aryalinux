#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:wireless_tools.:29



cd $SOURCE_DIR

URL=http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/wireless_tools.29.tar.gz

wget -nc http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/wireless_tools.29.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/wireless_tools/wireless_tools.29.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/wireless_tools/wireless_tools.29.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/wireless_tools/wireless_tools.29.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/wireless_tools/wireless_tools.29.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/wireless_tools/wireless_tools.29.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make PREFIX=/usr INSTALL_MAN=/usr/share/man install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "wireless_tools=>`date`" | sudo tee -a $INSTALLED_LIST

