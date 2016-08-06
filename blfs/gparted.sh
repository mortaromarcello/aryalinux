#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gparted:0.26.1

#REQ:gtkmm2
#REQ:parted
#OPT:rarian


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/gparted/gparted-0.26.1.tar.gz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gparted/gparted-0.26.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gparted/gparted-0.26.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gparted/gparted-0.26.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gparted/gparted-0.26.1.tar.gz || wget -nc http://downloads.sourceforge.net/gparted/gparted-0.26.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gparted/gparted-0.26.1.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr    \
            --disable-doc    \
            --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cp -v /usr/share/applications/gparted.desktop /usr/share/applications/gparted.desktop.back &&
sed -i 's/Exec=/Exec=sudo -A /'               /usr/share/applications/gparted.desktop

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gparted=>`date`" | sudo tee -a $INSTALLED_LIST
