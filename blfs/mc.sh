#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:mc:4.8.15

#REQ:glib2
#REQ:pcre
#REC:slang
#OPT:doxygen
#OPT:gpm
#OPT:samba
#OPT:unzip
#OPT:zip
#OPT:xorg-server


cd $SOURCE_DIR

URL=http://ftp.midnight-commander.org/mc-4.8.15.tar.xz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mc/mc-4.8.15.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mc/mc-4.8.15.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mc/mc-4.8.15.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mc/mc-4.8.15.tar.xz || wget -nc http://ftp.midnight-commander.org/mc-4.8.15.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/midnightcommander/mc-4.8.15.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mc/mc-4.8.15.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --enable-charset &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
cp -v doc/keybind-migration.txt /usr/share/mc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "mc=>`date`" | sudo tee -a $INSTALLED_LIST
