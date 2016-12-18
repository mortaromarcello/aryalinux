#!/bin/bash

#############################################################################
## Name:                                                                   ##
## Version:                                                                ##
## Packager: Mortaro Marcello (mortaromarcello@gmail.com)                  ##
## Homepage:                                                               ##
#############################################################################
set -e
set +h

#. /etc/alps/alps.conf
#. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="\n WPA Supplicant is a Wi-Fi\n Protected Access (WPA) client and IEEE 802.1X supplicant. It\n implements WPA key negotiation with a WPA Authenticator and\n Extensible Authentication Protocol (EAP) authentication with an\n Authentication Server. In addition, it controls the roaming and\n IEEE 802.11 authentication/association of the wireless LAN driver.\n This is useful for connecting to a password protected wireless\n access point.\n"
SECTION="basicnet"
VERSION=2.6
NAME="wpa_supplicant"
PKGNAME=$NAME

#REC:libnl
#REC:openssl
#REC:desktop-file-utils
#REC:dbus
#REC:libxml2
#REC:dhcp
#OPT:qt5

#LOC=""
ARCH=`uname -m`

START=`pwd`
PKG=$START/pkg
SRC=$START/work
function unzip_file()
{
	dir_name=$(unzip_dirname $1 $2)
	echo $dir_name
	if [ `echo $dir_name | grep "extracted$"` ]
	then
		echo "Create and extract..."
		mkdir $dir_name
		cp $1 $dir_name
		cd $dir_name
		unzip $1
		cd ..
	else
		echo "Just Extract..."
		unzip $1
	fi
}
function build() {
    mkdir -vp $PKG $SRC
    cd $SRC
    URL=http://hostap.epitest.fi/releases/wpa_supplicant-2.6.tar.gz
    if [ ! -z $URL ]; then
        wget -nc http://hostap.epitest.fi/releases/wpa_supplicant-2.6.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/wpa_supplicant/wpa_supplicant-2.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/wpa_supplicant/wpa_supplicant-2.6.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/wpa_supplicant/wpa_supplicant-2.6.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/wpa_supplicant/wpa_supplicant-2.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/wpa_supplicant/wpa_supplicant-2.6.tar.gz
        TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
        if [ -z $(echo $TARBALL | grep ".zip$") ]; then
            DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
            tar --no-overwrite-dir -xf $TARBALL
        else
            DIRECTORY=$(unzip_dirname $TARBALL $NAME)
            unzip_file $TARBALL $NAME
        fi
        cd $DIRECTORY
    fi
    #whoami > /tmp/currentuser
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
    # compiling package , preinstall and postinstall
    cd wpa_supplicant && make BINDIR=/sbin LIBDIR=/lib
    install -v -m755 wpa_{cli,passphrase,supplicant} $PKG/sbin/ &&
    install -v -m644 doc/docbook/wpa_supplicant.conf.5 $PKG/usr/share/man/man5/ &&
    install -v -m644 doc/docbook/wpa_{cli,passphrase,supplicant}.8 $PKG/usr/share/man/man8/
    install -v -m644 dbus/fi.{epitest.hostap.WPASupplicant,w1.wpa_supplicant1}.service $PKG/usr/share/dbus-1/system-services/

    #./configure --prefix=/usr
    #make
    #make DESTDIR=$PKG install
    #
}

function package() {
    strip -s $PKG/sbin/*
    #chown -R root:root usr/bin
    gzip -9 $PKG/usr/share/man/man?/*.?
    cd $PKG
    find . -type f -name "*"|sed 's/^.//' > $START/$PKGNAME-$VERSION-$ARCH-1.files
    find . -type d -name "*"|sed 's/^.//' >> $START/$PKGNAME-$VERSION-$ARCH-1.files
    mkdir $PKG/install
    echo -e $DESCRIPTION > $PKG/install/blfs-desc
    tar cvvf - . --format gnu --xform 'sx^\./\(.\)x\1x' --show-stored-names --group 0 --owner 0 | gzip > $START/$PKGNAME-$VERSION-$ARCH-1.tgz
    echo "blfs package \"$1\" created."
}
build
package

if [ ! -z $URL ]; then
    cd $START && rm -vrf $PKG && rm -vrf $SRC
fi
