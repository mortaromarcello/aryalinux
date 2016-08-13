#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:sawfish_:1.11

#REQ:rep-gtk
#REQ:general_which


cd $SOURCE_DIR

URL=http://download.tuxfamily.org/sawfish/sawfish_1.11.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sawfish/sawfish_1.11.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sawfish/sawfish_1.11.tar.xz || wget -nc http://download.tuxfamily.org/sawfish/sawfish_1.11.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sawfish/sawfish_1.11.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sawfish/sawfish_1.11.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sawfish/sawfish_1.11.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --with-pango  &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cat >> ~/.xinitrc << "EOF"
exec sawfish
EOF


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "sawfish=>`date`" | sudo tee -a $INSTALLED_LIST

