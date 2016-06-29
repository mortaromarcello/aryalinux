#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:sshfs-fuse:2.5

#REQ:fuse
#REQ:glib2
#REQ:openssh


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/fuse/sshfs-fuse-2.5.tar.gz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sshfs-fuse/sshfs-fuse-2.5.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sshfs-fuse/sshfs-fuse-2.5.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sshfs-fuse/sshfs-fuse-2.5.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sshfs-fuse/sshfs-fuse-2.5.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sshfs-fuse/sshfs-fuse-2.5.tar.gz || wget -nc http://downloads.sourceforge.net/fuse/sshfs-fuse-2.5.tar.gz

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


sshfs THINGY:~ ~/MOUNTPATH


fusermount -u ~/MOUNTPATH


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "sshfs-fuse=>`date`" | sudo tee -a $INSTALLED_LIST

