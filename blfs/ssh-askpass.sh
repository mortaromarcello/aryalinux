#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:openssh:7.2p2

#REQ:gtk2
#REQ:sudo
#REQ:x7lib
#REQ:xorg-server


cd $SOURCE_DIR

URL=http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.2p2.tar.gz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openssh/openssh-7.2p2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openssh/openssh-7.2p2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openssh/openssh-7.2p2.tar.gz || wget -nc ftp://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.2p2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openssh/openssh-7.2p2.tar.gz || wget -nc http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.2p2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openssh/openssh-7.2p2.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

cd contrib &&
make gnome-ssh-askpass2



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -d -m755                  /usr/libexec/openssh/contrib     &&
install -v -m755  gnome-ssh-askpass2 /usr/libexec/openssh/contrib     &&
ln -sv -f contrib/gnome-ssh-askpass2 /usr/libexec/openssh/ssh-askpass

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/sudo.conf << "EOF" &&
# Path to askpass helper program
Path askpass /usr/libexec/openssh/ssh-askpass
EOF
chmod -v 0644 /etc/sudo.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "ssh-askpass=>`date`" | sudo tee -a $INSTALLED_LIST

