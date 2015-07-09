#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:openssl


cd $SOURCE_DIR

wget -nc http://mirrors.zerg.biz/stunnel/stunnel-5.10.tar.gz
wget -nc ftp://ftp.stunnel.org/stunnel/stunnel-5.10.tar.gz


TARBALL=stunnel-5.10.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998750.sh << "ENDOFFILE"
groupadd -g 51 stunnel &&
useradd -c "stunnel Daemon" -d /var/lib/stunnel \
        -g stunnel -s /bin/false -u 51 stunnel
ENDOFFILE
chmod a+x 1434987998750.sh
sudo ./1434987998750.sh
sudo rm -rf 1434987998750.sh

sed -i /syslog.target/d tools/stunnel.service.in

sed -i '/LDFLAGS.*static_flag/ s/^/#/' configure

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var &&
make

cat > 1434987998750.sh << "ENDOFFILE"
make docdir=/usr/share/doc/stunnel-5.10 install
ENDOFFILE
chmod a+x 1434987998750.sh
sudo ./1434987998750.sh
sudo rm -rf 1434987998750.sh

cat > 1434987998750.sh << "ENDOFFILE"
install -v -m644 tools/stunnel.service /lib/systemd/system/stunnel.service
ENDOFFILE
chmod a+x 1434987998750.sh
sudo ./1434987998750.sh
sudo rm -rf 1434987998750.sh

cat > 1434987998750.sh << "ENDOFFILE"
make cert
ENDOFFILE
chmod a+x 1434987998750.sh
sudo ./1434987998750.sh
sudo rm -rf 1434987998750.sh

cat > 1434987998750.sh << "ENDOFFILE"
install -v -m750 -o stunnel -g stunnel -d /var/lib/stunnel/run &&
chown stunnel:stunnel /var/lib/stunnel
ENDOFFILE
chmod a+x 1434987998750.sh
sudo ./1434987998750.sh
sudo rm -rf 1434987998750.sh

cat > 1434987998750.sh << "ENDOFFILE"
cat >/etc/stunnel/stunnel.conf << "EOF" &&
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
chmod -v 644 /etc/stunnel/stunnel.conf
ENDOFFILE
chmod a+x 1434987998750.sh
sudo ./1434987998750.sh
sudo rm -rf 1434987998750.sh

cat > 1434987998750.sh << "ENDOFFILE"
systemctl enable stunnel
ENDOFFILE
chmod a+x 1434987998750.sh
sudo ./1434987998750.sh
sudo rm -rf 1434987998750.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "stunnel=>`date`" | sudo tee -a $INSTALLED_LIST