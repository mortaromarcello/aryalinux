#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:stunnel:5.31

#REQ:openssl


cd $SOURCE_DIR

URL=ftp://ftp.stunnel.org/stunnel/archive/5.x/stunnel-5.31.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/stunnel/stunnel-5.31.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/stunnel/stunnel-5.31.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/stunnel/stunnel-5.31.tar.gz || wget -nc ftp://ftp.stunnel.org/stunnel/archive/5.x/stunnel-5.31.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/stunnel/stunnel-5.31.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/stunnel/stunnel-5.31.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 51 stunnel &&
useradd -c "stunnel Daemon" -d /var/lib/stunnel \
        -g stunnel -s /bin/false -u 51 stunnel

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


sed -i '/LDFLAGS.*static_flag/ s/^/#/' configure


./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/stunnel-5.31 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 tools/stunnel.service /lib/systemd/system/stunnel.service

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make cert

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m750 -o stunnel -g stunnel -d /var/lib/stunnel/run &&
chown stunnel:stunnel /var/lib/stunnel

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >/etc/stunnel/stunnel.conf << "EOF" 
; File: /etc/stunnel/stunnel.conf
; Note: The pid and output locations are relative to the chroot location.
pid = /run/stunnel.pid
chroot = /var/lib/stunnel
client = no
setuid = stunnel
setgid = stunnel
cert = /etc/stunnel/stunnel.pem
;debug = 7
;output = stunnel.log
;[https]
;accept = 443
;connect = 80
;; "TIMEOUTclose = 0" is a workaround for a design flaw in Microsoft SSL
;; Microsoft implementations do not use SSL close-notify alert and thus
;; they are vulnerable to truncation attacks
;TIMEOUTclose = 0
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable stunnel

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "stunnel=>`date`" | sudo tee -a $INSTALLED_LIST

