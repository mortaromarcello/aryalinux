#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:nfs-utils:1.3.3

#REQ:libtirpc
#REQ:rpcbind
#OPT:libevent
#OPT:sqlite
#OPT:libnfsidmap
#OPT:mitkrb
#OPT:libcap


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/nfs/nfs-utils-1.3.3.tar.bz2

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nfs-utils/nfs-utils-1.3.3.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nfs-utils/nfs-utils-1.3.3.tar.bz2 || wget -nc http://downloads.sourceforge.net/nfs/nfs-utils-1.3.3.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nfs-utils/nfs-utils-1.3.3.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nfs-utils/nfs-utils-1.3.3.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nfs-utils/nfs-utils-1.3.3.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
if ! grep "^nogroup" /etc/group &> /dev/null; then
    groupadd -g 99 nogroup
fi

if ! grep "^nobody" /etc/passwd &> /dev/null; then
    useradd -c "Unprivileged Nobody" -d /dev/null -g nogroup \
        -s /bin/false -u 99 nobody
fi

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --without-tcp-wrappers \
            --disable-nfsv4        \
            --disable-gss &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chmod u+w,go+r /sbin/mount.nfs

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.08/blfs-systemd-units-20160602.tar.xz -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-nfs-client

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602.tar.xz
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "nfs-utils=>`date`" | sudo tee -a $INSTALLED_LIST

