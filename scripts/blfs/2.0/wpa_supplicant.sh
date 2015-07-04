#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libnl
#DEP:openssl


cd $SOURCE_DIR

wget -nc http://hostap.epitest.fi/releases/wpa_supplicant-2.3.tar.gz


TARBALL=wpa_supplicant-2.3.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > wpa_supplicant/.config << "EOF"
CONFIG_BACKEND=file
CONFIG_CTRL_IFACE=y
CONFIG_DEBUG_FILE=y
CONFIG_DEBUG_SYSLOG=y
CONFIG_DEBUG_SYSLOG_FACILITY=LOG_DAEMON
CONFIG_DRIVER_NL80211=y
CONFIG_DRIVER_WEXT=y
CONFIG_DRIVER_WIRED=y
CONFIG_EAP_GTC=y
CONFIG_EAP_LEAP=y
CONFIG_EAP_MD5=y
CONFIG_EAP_MSCHAPV2=y
CONFIG_EAP_OTP=y
CONFIG_EAP_PEAP=y
CONFIG_EAP_TLS=y
CONFIG_EAP_TTLS=y
CONFIG_IEEE8021X_EAPOL=y
CONFIG_IPV6=y
CONFIG_LIBNL32=y
CONFIG_PEERKEY=y
CONFIG_PKCS12=y
CONFIG_READLINE=y
CONFIG_SMARTCARD=y
CONFIG_WPS=y
CFLAGS += -I/usr/include/libnl3
EOF

cat >> wpa_supplicant/.config << "EOF"
CONFIG_CTRL_IFACE_DBUS=y
CONFIG_CTRL_IFACE_DBUS_NEW=y
CONFIG_CTRL_IFACE_DBUS_INTRO=y
EOF

sed -e "s@wpa_supplicant -u@& -s -O /var/run/wpa_supplicant@g" -i wpa_supplicant/dbus/*.service.in &&
sed -e "s@wpa_supplicant -u@& -s -O /var/run/wpa_supplicant@g" -i wpa_supplicant/systemd/wpa_supplicant.service.in

cd wpa_supplicant &&
make BINDIR=/sbin LIBDIR=/lib

cat > 1434987998782.sh << "ENDOFFILE"
install -v -m755 wpa_{cli,passphrase,supplicant} /sbin/ &&
install -v -m644 doc/docbook/wpa_supplicant.conf.5 /usr/share/man/man5/ &&
install -v -m644 doc/docbook/wpa_{cli,passphrase,supplicant}.8 /usr/share/man/man8/
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh

cat > 1434987998782.sh << "ENDOFFILE"
install -v -m644 systemd/*.service /lib/systemd/system/
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh

cat > 1434987998782.sh << "ENDOFFILE"
install -v -m644 dbus/fi.{epitest.hostap.WPASupplicant,w1.wpa_supplicant1}.service \
                 /usr/share/dbus-1/system-services/ &&
install -v -m644 dbus/dbus-wpa_supplicant.conf \
                 /etc/dbus-1/system.d/wpa_supplicant.conf
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh

cat > 1434987998782.sh << "ENDOFFILE"
systemctl enable wpa_supplicant
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh

cat > 1434987998782.sh << "ENDOFFILE"
install -v -dm755 /etc/wpa_supplicant
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "wpa_supplicant=>`date`" | sudo tee -a $INSTALLED_LIST