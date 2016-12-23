#!/bin/bash

#############################################################################
## Name:                                                                   ##
## Version:                                                                ##
## Packager: Mortaro Marcello (mortaromarcello@gmail.com)                  ##
## Homepage:                                                               ##
#############################################################################
set -e
set +h

SOURCE_ONLY=n
DESCRIPTION="\n WPA Supplicant is a Wi-Fi\n Protected Access (WPA) client and IEEE 802.1X supplicant. It\n implements WPA key negotiation with a WPA Authenticator and\n Extensible Authentication Protocol (EAP) authentication with an\n Authentication Server. In addition, it controls the roaming and\n IEEE 802.11 authentication/association of the wireless LAN driver.\n This is useful for connecting to a password protected wireless\n access point.\n"
SECTION="basicnet"
VERSION=2.6
NAME="wpa_supplicant"
PKGNAME=$NAME
REVISION=1

#REC:libnl
#REC:openssl
#REC:desktop-file-utils
#REC:dbus
#REC:libxml2
#REC:dhcp
#OPT:qt5

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
    cd $PKG
    case $(uname -m) in
        x86_64)
            mkdir -vp lib
            ln -sv lib lib64
            mkdir -vp usr/lib
            ln -sv lib usr/lib64
            mkdir -vp usr/local/lib
            ln -sv lib usr/local/lib64 ;;
    esac
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
    cd wpa_supplicant && make BINDIR=/sbin LIBDIR=/lib
    mkdir -vp $PKG/sbin
    install -v -m755 wpa_{cli,passphrase,supplicant} $PKG/sbin/ &&
    mkdir -vp $PKG/usr/share/man/man{5,8}
    install -v -m644 doc/docbook/wpa_supplicant.conf.5 $PKG/usr/share/man/man5/ &&
    install -v -m644 doc/docbook/wpa_{cli,passphrase,supplicant}.8 $PKG/usr/share/man/man8/
    mkdir -vp $PKG/usr/share/dbus-1/system-services
    install -v -m644 dbus/fi.{epitest.hostap.WPASupplicant,w1.wpa_supplicant1}.service $PKG/usr/share/dbus-1/system-services/
    mkdir -vp $PKG/lib/services
    cat > $PKG/lib/services/wpa << "EOF"
#!/bin/bash
# Begin services/wpa

# Origianlly based upon lfs-bootscripts-1.12 $NETWORK_DEVICES/if{down,up}
# Written by Armin K. <krejzi at email dot com>

# Call with: IFCONFIG=<filename> /lib/services/wpa <IFACE> <up | down>

#$LastChangedBy: bdubbs $
#$Date: 2015-03-04 16:39:39 -0600 (Wed, 04 Mar 2015) $

. /lib/lsb/init-functions
. $IFCONFIG

CFGFILE=/etc/sysconfig/wpa_supplicant-${IFCONFIG##*.}.conf
PIDFILE=/run/wpa_supplicant/$1.pid
CONTROL_IFACE=/run/wpa_supplicant/$1

case "$2" in
   up)

      if [ -e ${PIDFILE} ]; then
         ps $(cat ${PIDFILE}) | grep wpa_supplicant >/dev/null
         if [ "$?" = "0" ]; then
            log_warning_msg "\n wpa_supplicant already running on $1."
            exit 0
         else
            rm ${PIDFILE}
         fi
      fi

      if [ ! -e ${CFGFILE} ]; then
        log_info_msg "\n wpa_supplicant configuration file ${CFGFILE} not present"
        log_failure_msg2
        exit 1
      fi

      # Only specify -C on command line if it is not in CFGFILE
      if ! grep -q ctrl_interface ${CFGFILE}; then 
         WPA_ARGS="-C/run/wpa_supplicant ${WPA_ARGS}"
      fi

      log_info_msg "\n Starting wpa_supplicant on the $1 interface..."

      mkdir -p /run/wpa_supplicant

      /sbin/wpa_supplicant -q -B -Dnl80211,wext -P${PIDFILE} \
          -c${CFGFILE} -i$1 ${WPA_ARGS}

      if [ "$?" != "0" ]; then
        log_failure_msg2
        exit 1
      fi

      log_success_msg2

      if [ -n "${WPA_SERVICE}" ]; then
         if [ ! -e /lib/services/${WPA_SERVICE} -a \
              ! -x /lib/services/${WPA_SERVICE} ]; then
            log_info_msg "\n Cannot start ${WPA_SERVICE} on $1"
            log_failure_msg2
            exit 1
         fi

         IFCONFIG=${IFCONFIG} /lib/services/${WPA_SERVICE} $1 up
      fi
   ;;

   down)
      if [ -n "${WPA_SERVICE}" ]; then
         if [ ! -e /lib/services/${WPA_SERVICE} -a ! -x /lib/services/${WPA_SERVICE} ]; then
            log_warning_msg "\n Cannot stop ${WPA_SERVICE} on $1"
         else
            IFCONFIG=${IFCONFIG} /lib/services/${WPA_SERVICE} $1 down
         fi
      fi

      log_info_msg "\n Stopping wpa_supplicant on the $1 interface..."

      if [ -e ${PIDFILE} ]; then
         kill -9 $(cat ${PIDFILE})
         rm -f ${PIDFILE} ${CONTROL_IFACE}
         evaluate_retval
      else
         log_warning_msg "\n wpa_supplicant already stopped on $1"
         exit 0
      fi
   ;;

   *)
      echo "Usage: $0 [interface] {up|down}"
      exit 1
   ;;
esac

# End services/wpa

EOF
    chmod 754 $PKG/lib/services/wpa
    mkdir -vp $PKG/etc/sysconfig
    cat > $PKG/etc/sysconfig/ifconfig.wifi0 << "EOF"
ONBOOT="yes"
IFACE="wlan0"
SERVICE="wpa"
# Additional arguments to wpa_supplicant
WPA_ARGS="-c/etc/sysconfig/wpa_supplicant-wifi0.conf"
WPA_SERVICE="dhclient"
DHCP_START=""
DHCP_STOP=""
# Set PRINTIP="yes" to have the script print
# the DHCP assigned IP address
PRINTIP="no"
# Set PRINTALL="yes" to print the DHCP assigned values for
# IP, SM, DG, and 1st NS. This requires PRINTIP="yes".
PRINTALL="no"
EOF
}

function package() {
    strip -s $PKG/sbin/*
    gzip -9 $PKG/usr/share/man/man?/*.?
    cd $PKG
    find . -type f -name "*"|sed 's/^.//' > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files
    find . -type d -name "*"|sed 's/^.//' >> $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files
    gzip -f $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files.gz
    mkdir -vp $PKG/install
    mv -v $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files.gz $PKG/install/
    echo -e $DESCRIPTION > $PKG/install/blfs-desc
    cat > $PKG/install/doinst.sh << "EOF"
#!/bin/sh
update-desktop-database
EOF
    tar cvvf - . --format gnu --xform 'sx^\./\(.\)x\1x' --show-stored-names --group 0 --owner 0 | gzip > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.tgz
    echo "blfs package \"$PKGNAME-$VERSION-$ARCH-$REVISION.tgz\" created."
}
build
package

if [ ! -z $URL ]; then
    cd $START && rm -vrf $PKG && rm -vrf $SRC
fi
