#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The XScreenSaver is a modularbr3ak screen saver and locker for the X Window System. It is highlybr3ak customizable and allows the use of any program that can draw on thebr3ak root window as a display mode. The purpose of XScreenSaver is to display pretty pictures onbr3ak your screen when it is not in use, in keeping with the philosophybr3ak that unattended monitors should always be doing somethingbr3ak interesting, just like they do in the movies. However, XScreenSaver can also be used as a screenbr3ak locker, to prevent others from using your terminal while you arebr3ak away.br3ak
#SECTION:xsoft

whoami > /tmp/currentuser

#REQ:libglade
#REQ:x7app
#REC:glu
#OPT:gdm
#OPT:linux-pam


#VER:xscreensaver:5.36


NAME="xscreensaver"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xscreensaver/xscreensaver-5.36.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xscreensaver/xscreensaver-5.36.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xscreensaver/xscreensaver-5.36.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xscreensaver/xscreensaver-5.36.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xscreensaver/xscreensaver-5.36.tar.gz || wget -nc http://www.jwz.org/xscreensaver/xscreensaver-5.36.tar.gz


URL=http://www.jwz.org/xscreensaver/xscreensaver-5.36.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/pam.d/xscreensaver << "EOF"
# Begin /etc/pam.d/xscreensaver
auth include system-auth
account include system-account
# End /etc/pam.d/xscreensaver
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
