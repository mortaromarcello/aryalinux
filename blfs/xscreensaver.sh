#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:xscreensaver:5.35

#REQ:libglade
#REQ:x7app
#REC:glu
#OPT:linux-pam


cd $SOURCE_DIR

URL=http://www.jwz.org/xscreensaver/xscreensaver-5.35.tar.gz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xscreensaver/xscreensaver-5.35.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xscreensaver/xscreensaver-5.35.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xscreensaver/xscreensaver-5.35.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xscreensaver/xscreensaver-5.35.tar.gz || wget -nc http://www.jwz.org/xscreensaver/xscreensaver-5.35.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xscreensaver/xscreensaver-5.35.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
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
echo "xscreensaver=>`date`" | sudo tee -a $INSTALLED_LIST

