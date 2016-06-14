#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:sg3_utils:1.42



cd $SOURCE_DIR

URL=http://sg.danny.cz/sg/p/sg3_utils-1.42.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sg3_utils/sg3_utils-1.42.tar.xz || wget -nc http://sg.danny.cz/sg/p/sg3_utils-1.42.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sg3_utils/sg3_utils-1.42.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sg3_utils/sg3_utils-1.42.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sg3_utils/sg3_utils-1.42.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sg3_utils/sg3_utils-1.42.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "sg3_utils=>`date`" | sudo tee -a $INSTALLED_LIST

