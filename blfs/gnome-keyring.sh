#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gnome-keyring:3.20.0

#REQ:dbus
#REQ:gcr
#REC:linux-pam
#REC:libxslt
#OPT:gnupg
#OPT:openssh
#OPT:valgrind


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gnome-keyring/3.20/gnome-keyring-3.20.0.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-keyring/gnome-keyring-3.20.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-keyring/gnome-keyring-3.20.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-keyring/3.20/gnome-keyring-3.20.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-keyring/3.20/gnome-keyring-3.20.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-keyring/gnome-keyring-3.20.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-keyring/gnome-keyring-3.20.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-keyring/gnome-keyring-3.20.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i -r 's:"(/desktop):"/org/gnome\1:' schema/*.xml &&
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --with-pam-dir=/lib/security &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gnome-keyring=>`date`" | sudo tee -a $INSTALLED_LIST

