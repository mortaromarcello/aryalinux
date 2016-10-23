#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The ssh-askpass is a genericbr3ak executable name for many packages, with similar names, that providebr3ak a interactive X service to grab password for packages requiringbr3ak administrative privileges to be run. It prompts the user with abr3ak window box where the necessary password can be inserted. Here, webr3ak choose Damien Miller's package distributed in the OpenSSH tarball.br3ak
#SECTION:postlfs

whoami > /tmp/currentuser

#REQ:gtk2
#REQ:sudo
#REQ:x7lib
#REQ:xorg-server


#VER:openssh:7.3p1


NAME="ssh-askpass"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.3p1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openssh/openssh-7.3p1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openssh/openssh-7.3p1.tar.gz || wget -nc http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.3p1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openssh/openssh-7.3p1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openssh/openssh-7.3p1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openssh/openssh-7.3p1.tar.gz


URL=http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.3p1.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

cd contrib &&
make gnome-ssh-askpass2



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -d -m755 /usr/libexec/openssh/contrib  &&
install -v -m755    gnome-ssh-askpass2 \
                    /usr/libexec/openssh/contrib  &&
ln -sv -f contrib/gnome-ssh-askpass2 \
                    /usr/libexec/openssh/ssh-askpass

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

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST