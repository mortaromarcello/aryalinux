#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The LVM2 package is a set of toolsbr3ak that manage logical partitions. It allows spanning of file systemsbr3ak across multiple physical disks and disk partitions and provides forbr3ak dynamic growing or shrinking of logical partitions, mirroring andbr3ak low storage footprint snapshots.br3ak
#SECTION:postlfs

whoami > /tmp/currentuser

#OPT:mdadm
#OPT:reiserfs
#OPT:valgrind
#OPT:general_which
#OPT:xfsprogs


#VER:LVM:2.2.02.164


NAME="lvm2"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lvm2/LVM2.2.02.164.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lvm2/LVM2.2.02.164.tgz || wget -nc ftp://sources.redhat.com/pub/lvm2/releases/LVM2.2.02.164.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lvm2/LVM2.2.02.164.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lvm2/LVM2.2.02.164.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lvm2/LVM2.2.02.164.tgz


URL=ftp://sources.redhat.com/pub/lvm2/releases/LVM2.2.02.164.tgz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

SAVEPATH=$PATH                  &&
PATH=$PATH:/sbin:/usr/sbin      &&
./configure --prefix=/usr       \
            --exec-prefix=      \
            --with-confdir=/etc \
            --enable-applib     \
            --enable-cmdlib     \
            --enable-pkgconfig  \
            --enable-udev_sync  &&
make                            &&
PATH=$SAVEPATH                  &&
unset SAVEPATH



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C tools install_dmsetup_dynamic &&
make -C udev  install                 &&
make -C libdm install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST