#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:openssh:7.2p2

#REQ:openssl
#OPT:linux-pam
#OPT:mitkrb
#OPT:openjdk
#OPT:net-tools
#OPT:sysstat
#OPT:xorg-server


cd $SOURCE_DIR

URL=http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.2p2.tar.gz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openssh/openssh-7.2p2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openssh/openssh-7.2p2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openssh/openssh-7.2p2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openssh/openssh-7.2p2.tar.gz || wget -nc http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.2p2.tar.gz || wget -nc ftp://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.2p2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openssh/openssh-7.2p2.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m700 -d /var/lib/sshd &&
chown   -v root:sys /var/lib/sshd &&
groupadd -g 50 sshd &&
useradd -c 'sshd PrivSep' -d /var/lib/sshd -g sshd -s /bin/false -u 50 sshd

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


./configure --prefix=/usr                     \
            --sysconfdir=/etc/ssh             \
            --with-md5-passwords              \
            --with-privsep-path=/var/lib/sshd &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                                  &&
install -v -m755 contrib/ssh-copy-id /usr/bin &&
install -v -m644 contrib/ssh-copy-id.1 /usr/share/man/man1 &&
install -v -m755 -d /usr/share/doc/openssh-7.2p2           &&
install -v -m644 INSTALL LICENCE OVERVIEW README* /usr/share/doc/openssh-7.2p2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
echo "PermitRootLogin no" >> /etc/ssh/sshd_config

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config &&
echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed 's@d/login@d/sshd@g' /etc/pam.d/login > /etc/pam.d/sshd &&
chmod 644 /etc/pam.d/sshd &&
echo "UsePAM yes" >> /etc/ssh/sshd_config

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20160602.tar.xz -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz
make install-sshd

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602.tar.xz
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl stop sshd && 
systemctl disable sshd &&
systemctl enable sshd.socket &&
systemctl start sshd.socket

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "openssh=>`date`" | sudo tee -a $INSTALLED_LIST

