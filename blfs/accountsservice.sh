#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:accountsservice:0.6.40

#REQ:polkit
#REC:gobject-introspection
#REC:systemd
#OPT:gtk-doc
#OPT:xmlto


cd $SOURCE_DIR

URL=http://www.freedesktop.org/software/accountsservice/accountsservice-0.6.40.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/accountsservice/accountsservice-0.6.40.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/accountsservice/accountsservice-0.6.40.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/accountsservice/accountsservice-0.6.40.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/accountsservice/accountsservice-0.6.40.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/accountsservice/accountsservice-0.6.40.tar.xz || wget -nc http://www.freedesktop.org/software/accountsservice/accountsservice-0.6.40.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr            \
            --sysconfdir=/etc        \
            --localstatedir=/var     \
            --enable-admin-group=adm \
            --disable-static         &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable accounts-daemon

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "accountsservice=>`date`" | sudo tee -a $INSTALLED_LIST

