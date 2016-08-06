#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:icewm:1.3.12

#REQ:gdk-pixbuf
#REQ:xorg-server
#OPT:libsndfile
#OPT:alsa-lib


cd $SOURCE_DIR

URL=https://github.com/bbidulock/icewm/releases/download/1.3.12/icewm-1.3.12.tar.bz2

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/icewm/icewm-1.3.12.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/icewm/icewm-1.3.12.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/icewm/icewm-1.3.12.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/icewm/icewm-1.3.12.tar.bz2 || wget -nc https://github.com/bbidulock/icewm/releases/download/1.3.12/icewm-1.3.12.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/icewm/icewm-1.3.12.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


./configure --prefix=/usr                     \
            --sysconfdir=/etc                 \
            --docdir=/usr/share/icewm-1.3.12 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install         &&
rm /usr/share/xsessions/icewm.desktop

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


echo icewm-session > ~/.xinitrc


mkdir -v ~/.icewm                                       &&
cp -v /usr/share/icewm/keys ~/.icewm/keys               &&
cp -v /usr/share/icewm/menu ~/.icewm/menu               &&
cp -v /usr/share/icewm/preferences ~/.icewm/preferences &&
cp -v /usr/share/icewm/toolbar ~/.icewm/toolbar         &&
cp -v /usr/share/icewm/winoptions ~/.icewm/winoptions


icewm-menu-fdo >~/.icewm/menu


cat > ~/.icewm/startup << "EOF"
rox -p Default &
EOF &&
chmod +x ~/.icewm/startup


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "icewm=>`date`" | sudo tee -a $INSTALLED_LIST
