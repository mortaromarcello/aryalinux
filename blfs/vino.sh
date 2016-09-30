#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:vino:3.20.2

#REQ:libnotify
#REC:gnutls
#REC:libgcrypt
#REC:libsecret
#REC:networkmanager
#REC:telepathy-glib
#OPT:avahi


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/vino/3.20/vino-3.20.2.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/vino/vino-3.20.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/vino/3.20/vino-3.20.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/vino/vino-3.20.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/vino/vino-3.20.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/vino/vino-3.20.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/vino/3.20/vino-3.20.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/vino/vino-3.20.2.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "vino=>`date`" | sudo tee -a $INSTALLED_LIST

