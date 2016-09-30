#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:btrfs-progs-v:4.7.1

#REQ:lzo
#REC:asciidoc
#REC:xmlto
#OPT:lvm2


cd $SOURCE_DIR

URL=https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v4.7.1.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/btrfs-progs/btrfs-progs-v4.7.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/btrfs-progs/btrfs-progs-v4.7.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/btrfs-progs/btrfs-progs-v4.7.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/btrfs-progs/btrfs-progs-v4.7.1.tar.xz || wget -nc https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v4.7.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/btrfs-progs/btrfs-progs-v4.7.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i '1,106 s/\.gz//g' Documentation/Makefile.in &&
./configure --prefix=/usr \
            --bindir=/bin \
            --libdir=/lib &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
ln -sfv ../../lib/$(readlink /lib/libbtrfs.so) /usr/lib/libbtrfs.so &&
rm -v /lib/libbtrfs.{a,so}

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "btrfs-progs=>`date`" | sudo tee -a $INSTALLED_LIST

