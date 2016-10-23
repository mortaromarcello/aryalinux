#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Seahorse is a graphical interfacebr3ak for managing and using encryption keys. Currently it supports PGPbr3ak keys (using GPG/GPGME) and SSH keys.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

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


#VER:seahorse:3.20.0


NAME="seahorse"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/seahorse/seahorse-3.20.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/seahorse/3.20/seahorse-3.20.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/seahorse/seahorse-3.20.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/seahorse/seahorse-3.20.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/seahorse/seahorse-3.20.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/seahorse/3.20/seahorse-3.20.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/seahorse/seahorse-3.20.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/seahorse/3.20/seahorse-3.20.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
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

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
