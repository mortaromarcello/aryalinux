#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The Ntfs-3g package contains abr3ak stable, read-write open source driver for NTFS partitions. NTFSbr3ak partitions are used by most Microsoft operating systems. Ntfs-3gbr3ak allows you to mount NTFS partitions in read-write mode from yourbr3ak Linux system. It uses the FUSE kernel module to be able tobr3ak implement NTFS support in user space.br3ak
#SECTION:postlfs

whoami > /tmp/currentuser

#REC:fuse


#VER:ntfs-3g_ntfsprogs:2016.2.22


NAME="ntfs-3g"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ntfs-3g/ntfs-3g_ntfsprogs-2016.2.22.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ntfs-3g/ntfs-3g_ntfsprogs-2016.2.22.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ntfs-3g/ntfs-3g_ntfsprogs-2016.2.22.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ntfs-3g/ntfs-3g_ntfsprogs-2016.2.22.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ntfs-3g/ntfs-3g_ntfsprogs-2016.2.22.tgz || wget -nc https://tuxera.com/opensource/ntfs-3g_ntfsprogs-2016.2.22.tgz


URL=https://tuxera.com/opensource/ntfs-3g_ntfsprogs-2016.2.22.tgz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static --with-fuse=external &&
make "-j`nproc`" || make



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
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
