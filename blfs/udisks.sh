#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:udisks:1.0.5

#REQ:dbus-glib
#REQ:libatasmart
#REQ:libgudev
#REQ:lvm2
#REQ:parted
#REQ:polkit
#REQ:sg3_utils
#REC:systemd
#OPT:gtk-doc
#OPT:libxslt
#OPT:sudo


cd $SOURCE_DIR

URL=http://hal.freedesktop.org/releases/udisks-1.0.5.tar.gz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/udisks/udisks-1.0.5.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/udisks/udisks-1.0.5.tar.gz || wget -nc http://hal.freedesktop.org/releases/udisks-1.0.5.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/udisks/udisks-1.0.5.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/udisks/udisks-1.0.5.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/udisks/udisks-1.0.5.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make profiledir=/etc/bash_completion.d install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "udisks=>`date`" | sudo tee -a $INSTALLED_LIST

