#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:pm-utils:1.4.1

#OPT:xmlto
#OPT:hdparm
#OPT:wireless_tools


cd $SOURCE_DIR

URL=http://pm-utils.freedesktop.org/releases/pm-utils-1.4.1.tar.gz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pm-utils/pm-utils-1.4.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pm-utils/pm-utils-1.4.1.tar.gz || wget -nc http://pm-utils.freedesktop.org/releases/pm-utils-1.4.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pm-utils/pm-utils-1.4.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pm-utils/pm-utils-1.4.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pm-utils/pm-utils-1.4.1.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/pm-utils-1.4.1 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 man/*.1 /usr/share/man/man1 &&
install -v -m644 man/*.8 /usr/share/man/man8 &&
ln -sv pm-action.8 /usr/share/man/man8/pm-suspend.8 &&
ln -sv pm-action.8 /usr/share/man/man8/pm-hibernate.8 &&
ln -sv pm-action.8 /usr/share/man/man8/pm-suspend-hybrid.8

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "pm-utils=>`date`" | sudo tee -a $INSTALLED_LIST

