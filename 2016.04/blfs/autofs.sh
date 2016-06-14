#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:autofs:5.1.1

#OPT:libtirpc
#OPT:nfs-utils
#OPT:libxml2
#OPT:mitkrb
#OPT:openldap
#OPT:cyrus-sasl


cd $SOURCE_DIR

URL=http://www.kernel.org/pub/linux/daemons/autofs/v5/autofs-5.1.1.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/autofs/autofs-5.1.1.tar.xz || wget -nc http://www.kernel.org/pub/linux/daemons/autofs/v5/autofs-5.1.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/autofs/autofs-5.1.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/autofs/autofs-5.1.1.tar.xz || wget -nc ftp://ftp.kernel.org/pub/linux/daemons/autofs/v5/autofs-5.1.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/autofs/autofs-5.1.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/autofs/autofs-5.1.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/         \
            --with-systemd     \
            --without-openldap \
            --mandir=/usr/share/man &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mv /etc/auto.master /etc/auto.master.bak &&
cat > /etc/auto.master << "EOF"
# Begin /etc/auto.master
/media/auto /etc/auto.misc --ghost
#/home /etc/auto.home
# End /etc/auto.master
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable autofs

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "autofs=>`date`" | sudo tee -a $INSTALLED_LIST

