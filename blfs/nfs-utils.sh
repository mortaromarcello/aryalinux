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
/home <em class="replaceable"><code>192.168.0.0/24</em>(rw,subtree_check,anonuid=99,anongid=99)

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.04/blfs-systemd-units-20150310.tar.bz2 -O $SOURCE_DIR/blfs-systemd-units-20150310.tar.bz2
tar xf $SOURCE_DIR/blfs-systemd-units-20150310.tar.bz2 -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20150310
make install-nfsv4-server

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20150310
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.04/blfs-systemd-units-20150310.tar.bz2 -O $SOURCE_DIR/blfs-systemd-units-20150310.tar.bz2
tar xf $SOURCE_DIR/blfs-systemd-units-20150310.tar.bz2 -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20150310
make install-nfs-server

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20150310
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
<em class="replaceable"><code><server-name></em>:/home  /home nfs   rw,_netdev 0 0
<em class="replaceable"><code><server-name></em>:/usr   /usr  nfs   ro,_netdev 0 0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.04/blfs-systemd-units-20150310.tar.bz2 -O $SOURCE_DIR/blfs-systemd-units-20150310.tar.bz2
tar xf $SOURCE_DIR/blfs-systemd-units-20150310.tar.bz2 -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20150310
make install-nfs-client

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20150310
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "nfs-utils=>`date`" | sudo tee -a $INSTALLED_LIST

