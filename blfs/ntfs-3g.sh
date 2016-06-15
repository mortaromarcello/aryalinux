#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:ntfs-3g_ntfsprogs:2015.3.14

#REC:fuse


cd $SOURCE_DIR

URL=https://tuxera.com/opensource/ntfs-3g_ntfsprogs-2015.3.14.tgz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ntfs-3g/ntfs-3g_ntfsprogs-2015.3.14.tgz || wget -nc https://tuxera.com/opensource/ntfs-3g_ntfsprogs-2015.3.14.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ntfs-3g/ntfs-3g_ntfsprogs-2015.3.14.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ntfs-3g/ntfs-3g_ntfsprogs-2015.3.14.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ntfs-3g/ntfs-3g_ntfsprogs-2015.3.14.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ntfs-3g/ntfs-3g_ntfsprogs-2015.3.14.tgz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static --with-fuse=external &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
ln -sv ../bin/ntfs-3g /sbin/mount.ntfs &&
ln -sv ntfs-3g.8 /usr/share/man/man8/mount.ntfs.8

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
chmod -v 4755 /sbin/mount.ntfs

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "ntfs-3g=>`date`" | sudo tee -a $INSTALLED_LIST

