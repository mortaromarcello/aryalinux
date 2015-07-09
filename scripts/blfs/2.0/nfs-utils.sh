#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libtirpc
#DEP:libevent
#DEP:libnfsidmap
#DEP:sqlite
#DEP:lvm2
#DEP:rpcbind


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/nfs/nfs-utils-1.3.2.tar.bz2


TARBALL=nfs-utils-1.3.2.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i "/daemon_init/s:\!::" utils/statd/statd.c

./configure --prefix=/usr           \
            --sysconfdir=/etc       \
            --sbindir=/sbin         \
            --enable-libmount-mount \
            --without-tcp-wrappers  \
            --disable-gss           &&
make

cat > 1434987998781.sh << "ENDOFFILE"
make install &&
install -v -m644 utils/mount/nfsmount.conf /etc/nfsmount.conf
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh

cat > 1434987998781.sh << "ENDOFFILE"
install -v -dm555 /var/lib/nfs/rpc_pipefs &&
install -v -dm755 /var/lib/nfs/v4recovery &&
cat > /etc/idmapd.conf << "EOF"
[General]
Verbosity = 0
Pipefs-Directory = /var/lib/nfs/rpc_pipefs
Domain = localdomain

[Mapping]
Nobody-User = nobody
Nobody-Group = nogroup

[Translation]
Method = nsswitch
EOF
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh

cat > 1434987998781.sh << "ENDOFFILE"
/home <em class="replaceable"><code>192.168.0.0/24</em>(rw,no_subtree_check,anonuid=99,anongid=99)
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh

cat > 1434987998781.sh << "ENDOFFILE"
install -v -dm755 /srv/nfsv4/home &&
mount -v --bind /home /srv/nfsv4/home
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh

cat > 1434987998781.sh << "ENDOFFILE"
/home /srv/nfsv4/home none bind 0 0
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh

cat > 1434987998781.sh << "ENDOFFILE"
/srv/nfsv4       <em class="replaceable"><code>192.168.0.0/24</em>(rw,fsid=0,no_subtree_check)
/srv/nfsv4/home  <em class="replaceable"><code>192.168.0.0/24</em>(rw,nohide,insecure,no_subtree_check)
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh

cat > 1434987998781.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-nfsv4-server
cd ..
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh

cat > 1434987998781.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-nfs-server
cd ..
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh

cat > 1434987998781.sh << "ENDOFFILE"
<em class="replaceable"><code><server-name></em>:/home /home nfs rw,x-systemd.automount,x-systemd.device-timeout=10,timeo=14 0 0
<em class="replaceable"><code><server-name></em>:/usr  /usr  nfs ro,x-systemd.automount,x-systemd.device-timeout=10,timeo=14 0 0
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh

cat > 1434987998781.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-nfs-client
cd ..
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "nfs-utils=>`date`" | sudo tee -a $INSTALLED_LIST