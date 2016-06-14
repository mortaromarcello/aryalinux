#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libpwquality:1.3.0

#REQ:cracklib
#OPT:linux-pam
#OPT:python2


cd $SOURCE_DIR

URL=https://fedorahosted.org/releases/l/i/libpwquality/libpwquality-1.3.0.tar.bz2

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpwquality/libpwquality-1.3.0.tar.bz2 || wget -nc https://fedorahosted.org/releases/l/i/libpwquality/libpwquality-1.3.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpwquality/libpwquality-1.3.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libpwquality/libpwquality-1.3.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libpwquality/libpwquality-1.3.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libpwquality/libpwquality-1.3.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr             \
            --sysconfdir=/etc         \
            --disable-python-bindings \
            --disable-static          \
            --with-securedir=/lib/security &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libpwquality=>`date`" | sudo tee -a $INSTALLED_LIST

