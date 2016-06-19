#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:lsof_:4.89

#REQ:libtirpc


cd $SOURCE_DIR

URL=ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_4.89.tar.bz2

wget -nc ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_4.89.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lsof/lsof_4.89.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lsof/lsof_4.89.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lsof/lsof_4.89.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lsof/lsof_4.89.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lsof/lsof_4.89.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

tar -xf lsof_4.89_src.tar  &&
cd lsof_4.89_src           &&
./Configure -n linux       &&
make CFGL="-L./lib -ltirpc"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m0755 -o root -g root lsof /usr/bin &&
install -v lsof.8 /usr/share/man/man8

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "lsof=>`date`" | sudo tee -a $INSTALLED_LIST
