#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:LVM:2.2.02.155

#OPT:mdadm
#OPT:reiserfs
#OPT:valgrind
#OPT:general_which
#OPT:xfsprogs


cd $SOURCE_DIR

URL=ftp://sources.redhat.com/pub/lvm2/releases/LVM2.2.02.155.tgz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lvm2/LVM2.2.02.155.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lvm2/LVM2.2.02.155.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lvm2/LVM2.2.02.155.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lvm2/LVM2.2.02.155.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lvm2/LVM2.2.02.155.tgz || wget -nc ftp://sources.redhat.com/pub/lvm2/releases/LVM2.2.02.155.tgz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
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
echo "lvm2=>`date`" | sudo tee -a $INSTALLED_LIST

