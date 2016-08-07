#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:vsftpd:3.0.3

#OPT:libcap
#OPT:linux-pam
#OPT:openssl


cd $SOURCE_DIR

URL=https://security.appspot.com/downloads/vsftpd-3.0.3.tar.gz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/vsftpd/vsftpd-3.0.3.tar.gz || wget -nc https://security.appspot.com/downloads/vsftpd-3.0.3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/vsftpd/vsftpd-3.0.3.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/vsftpd/vsftpd-3.0.3.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/vsftpd/vsftpd-3.0.3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/vsftpd/vsftpd-3.0.3.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -d -m 0755 /usr/share/vsftpd/empty &&
install -v -d -m 0755 /home/ftp               &&
groupadd -g 47 vsftpd                         &&
groupadd -g 45 ftp                            &&
useradd -c "vsftpd User"  -d /dev/null -g vsftpd -s /bin/false -u 47 vsftpd &&
useradd -c anonymous_user -d /home/ftp -g ftp    -s /bin/false -u 45 ftp

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m 755 vsftpd        /usr/sbin/vsftpd    &&
install -v -m 644 vsftpd.8      /usr/share/man/man8 &&
install -v -m 644 vsftpd.conf.5 /usr/share/man/man5 &&
install -v -m 644 vsftpd.conf   /etc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/vsftpd.conf << "EOF"
background=YES
listen=YES
nopriv_user=vsftpd
secure_chroot_dir=/usr/share/vsftpd/empty
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cat >> /etc/vsftpd.conf << "EOF"
local_enable=YES
EOF


cat > /etc/pam.d/vsftpd << "EOF" &&
# Begin /etc/pam.d/vsftpd
auth required /lib/security/pam_listfile.so item=user sense=deny \
 file=/etc/ftpusers \
 onerr=succeed
auth required pam_shells.so
auth include system-auth
account include system-account
session include system-session
EOF
cat >> /etc/vsftpd.conf << "EOF"
session_support=YES
pam_service_name=vsftpd
EOF



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.08/blfs-systemd-units-20160602.tar.xz -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-vsftpd

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602.tar.xz
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "vsftpd=>`date`" | sudo tee -a $INSTALLED_LIST

