#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:seahorse:3.20.0

#REQ:gcr
#REQ:gnupg
#REQ:gpgme
#REQ:itstool
#REQ:libsecret
#REQ:gnome-keyring
#REC:libsoup
#REC:openssh
#REC:vala
#OPT:avahi
#OPT:openldap


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/seahorse/3.20/seahorse-3.20.0.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/seahorse/seahorse-3.20.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/seahorse/3.20/seahorse-3.20.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/seahorse/seahorse-3.20.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/seahorse/seahorse-3.20.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/seahorse/seahorse-3.20.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/seahorse/3.20/seahorse-3.20.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/seahorse/seahorse-3.20.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i -r 's:"(/apps):"/org/gnome\1:' data/*.xml &&
./configure --prefix=/usr  &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "seahorse=>`date`" | sudo tee -a $INSTALLED_LIST

