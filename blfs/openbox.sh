#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:numlockx_.orig:1.2
#VER:openbox:3.6.1

#REQ:pango
#REQ:xorg-server
#OPT:dbus
#OPT:imlib2
#OPT:librsvg
#OPT:python-modules#pyxdg
#OPT:startup-notification


cd $SOURCE_DIR

URL=http://openbox.org/dist/openbox/openbox-3.6.1.tar.gz

wget -nc http://ftp.de.debian.org/debian/pool/main/n/numlockx/numlockx_1.2.orig.tar.gz
wget -nc http://openbox.org/dist/openbox/openbox-3.6.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openbox/openbox-3.6.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openbox/openbox-3.6.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openbox/openbox-3.6.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openbox/openbox-3.6.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openbox/openbox-3.6.1.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

2to3 -w data/autostart/openbox-xdg-autostart &&
sed 's/python/python3/' -i data/autostart/openbox-xdg-autostart


./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --docdir=/usr/share/doc/openbox-3.6.1 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "openbox=>`date`" | sudo tee -a $INSTALLED_LIST

