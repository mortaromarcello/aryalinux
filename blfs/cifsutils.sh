#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:cifs-utils:6.5

#OPT:keyutils
#OPT:linux-pam
#OPT:mitkrb
#OPT:talloc
#OPT:samba
#OPT:libcap


cd $SOURCE_DIR

URL=https://ftp.samba.org/pub/linux-cifs/cifs-utils/cifs-utils-6.5.tar.bz2

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cifs-utils/cifs-utils-6.5.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cifs-utils/cifs-utils-6.5.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cifs-utils/cifs-utils-6.5.tar.bz2 || wget -nc https://ftp.samba.org/pub/linux-cifs/cifs-utils/cifs-utils-6.5.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cifs-utils/cifs-utils-6.5.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cifs-utils/cifs-utils-6.5.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-pam &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "cifsutils=>`date`" | sudo tee -a $INSTALLED_LIST

