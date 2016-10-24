#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The btrfs-progs package containsbr3ak administration and debugging tools for the B-tree file systembr3ak (btrfs).br3ak
#SECTION:postlfs

whoami > /tmp/currentuser

#REQ:lzo
#REC:asciidoc
#REC:xmlto
#OPT:lvm2


#VER:btrfs-progs-v:4.8.1


NAME="btrfs-progs"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v4.8.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/btrfs-progs/btrfs-progs-v4.8.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/btrfs-progs/btrfs-progs-v4.8.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/btrfs-progs/btrfs-progs-v4.8.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/btrfs-progs/btrfs-progs-v4.8.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/btrfs-progs/btrfs-progs-v4.8.1.tar.xz


URL=https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v4.8.1.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i '1,106 s/\.gz//g' Documentation/Makefile.in &&
./configure --prefix=/usr \
            --bindir=/bin \
            --libdir=/lib &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
ln -sfv ../../lib/$(readlink /lib/libbtrfs.so) /usr/lib/libbtrfs.so &&
rm -v /lib/libbtrfs.{a,so}

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
