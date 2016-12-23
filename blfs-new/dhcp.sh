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
DESCRIPTION="\n The ISC DHCP package contains both\n the client and server programs for DHCP. <span class=\"command\"><strong>dhclient</strong> (the client) is used for\n connecting to a network which uses DHCP to assign network\n addresses. <span class=\"command\"><strong>dhcpd</strong> (the\n server) is used for assigning network addresses on private\n networks.\n"
SECTION="basicnet"
VERSION=4.3.5
NAME="dhcp"
PKGNAME=$NAME
REVISION=1

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
    URL=ftp://ftp.isc.org/isc/dhcp/4.3.5/dhcp-4.3.5.tar.gz
    if [ ! -z $URL ]; then
        wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/dhcp/dhcp-4.3.5.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/dhcp/dhcp-4.3.5.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/dhcp/dhcp-4.3.5.tar.gz || wget -nc ftp://ftp.isc.org/isc/dhcp/4.3.5/dhcp-4.3.5.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/dhcp/dhcp-4.3.5.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/dhcp/dhcp-4.3.5.tar.gz
        wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/dhcp-4.3.5-client_script-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/dhcp/dhcp-4.3.5-client_script-1.patch
        wget -nc http://www.linuxfromscratch.org/patches/downloads/dhcp/dhcp-4.3.5-missing_ipv6-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/dhcp-4.3.5-missing_ipv6-1.patch
        TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
        if [ -z $(echo $TARBALL | grep ".zip$") ]; then
            DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
            tar --no-overwrite-dir -xvf $TARBALL
        else
            DIRECTORY=$(unzip_dirname $TARBALL $NAME)
            unzip_file $TARBALL $NAME
        fi
        cd $DIRECTORY
    fi
    patch -Np1 -i ../dhcp-4.3.5-missing_ipv6-1.patch
    patch -Np1 -i ../dhcp-4.3.5-client_script-1.patch &&
    CFLAGS="-D_PATH_DHCLIENT_SCRIPT='\"/sbin/dhclient-script\"'         \
            -D_PATH_DHCPD_CONF='\"/etc/dhcp/dhcpd.conf\"'               \
            -D_PATH_DHCLIENT_CONF='\"/etc/dhcp/dhclient.conf\"'"        &&
    ./configure --prefix=/usr                                           \
                --sysconfdir=/etc/dhcp                                  \
                --localstatedir=/var                                    \
                --with-srv-lease-file=/var/lib/dhcpd/dhcpd.leases       \
                --with-srv6-lease-file=/var/lib/dhcpd/dhcpd6.leases     \
                --with-cli-lease-file=/var/lib/dhclient/dhclient.leases \
                --with-cli6-lease-file=/var/lib/dhclient/dhclient6.leases &&
    make -j1
    make DESTDIR=$PKG install &&
    mkdir -vp $PKG/sbin &&
    mv -v $PKG/usr/sbin/dhclient $PKG/sbin &&
    install -v -m755 client/scripts/linux $PKG/sbin/dhclient-script
    
    cat > $PKG/etc/dhcp/dhclient.conf << "EOF"
# Begin /etc/dhcp/dhclient.conf
#
# Basic dhclient.conf(5)
#prepend domain-name-servers 127.0.0.1;
request subnet-mask, broadcast-address, time-offset, routers,
 domain-name, domain-name-servers, domain-search, host-name,
 netbios-name-servers, netbios-scope, interface-mtu,
 ntp-servers;
require subnet-mask, domain-name-servers;
#timeout 60;
#retry 60;
#reboot 10;
#select-timeout 5;
#initial-interval 2;
# End /etc/dhcp/dhclient.conf
EOF
    install -v -dm 755 $PKG/var/lib/dhclient
    mkdir -vp $PKG/lib/services
    cat > $PKG/lib/services/dhclient << "EOF"
#!/bin/sh
# Begin services/dhclient

# Origianlly based upon lfs-bootscripts-1.12 $NETWORK_DEVICES/if{down,up}
# Rewritten by Nathan Coulson <nathan@linuxfromscratch.org>
# Adapted for dhclient by DJ Lucas <dj@linuxfromscratch.org>
# Update for LFS 7.0 by Ken Moffat <ken@linuxfromscratch.org>

# Call with: IFCONFIG=<filename> /lib/services/dhclient <IFACE> <up | down>

#$LastChangedBy: bdubbs $
#$Date: 2014-08-27 13:01:33 -0500 (Wed, 27 Aug 2014) $

. /lib/lsb/init-functions
. $IFCONFIG

PIDFILE=/run/dhclient-$1.pid
LFILE=/var/lib/dhclient/dhclient-$1.leases

getipstats()
{
   # Print the last 16 lines of dhclient.leases
   sed -e :a -e '$q;N;17,$D;ba' ${LFILE}
}

# Make compatible with older versions of init-functions
unset is_true

is_true()
{
   [ "$1" = "1" ] || [ "$1" = "yes" ] || [ "$1" = "true" ] ||
   [ "$1" = "y" ] || [ "$1" = "t" ]
}

case "$2" in
   up)

     if [ -e ${PIDFILE} ]; then
        ps $(cat ${PIDFILE}) | grep dhclient >/dev/null
        if [ "$?" = "0" ]; then
           log_warning_msg "\n      dhclient appears to be running on $1"
           exit 0
        else
           rm ${PIDFILE}
        fi
     fi

      log_info_msg "\n     Starting dhclient on the $1 interface..."

      /sbin/dhclient -lf ${LFILE} -pf ${PIDFILE} $DHCP_START $1

      if [ "$?" != "0" ]; then
        log_failure_msg2
        exit 1
      fi

      # Print the assigned settings if requested
      if  is_true "$PRINTIP"  -o  is_true "$PRINTALL"; then
        # Get info from dhclient.leases file

        IPADDR=`getipstats | grep "fixed-address" | \
          sed 's/ fixed-address //' | \
          sed 's/\;//'`

        NETMASK=`getipstats | grep "subnet-mask" | \
          sed 's/ option subnet-mask //' | \
          sed 's/\;//'`

        GATEWAY=`getipstats | grep "routers" | \
          sed 's/ option routers //' | \
          sed 's/\;//'`

        DNS=`getipstats | grep "domain-name-servers" | \
          sed 's/ option domain-name-servers //' | \
          sed 's/\;//' | sed 's/,/ and /'`

        if [ "$PRINTALL" = "yes" ]; then
           # This is messy, the messages are on one very long
           # line on the screen and in the log
           log_info_msg "           DHCP Assigned Settings for $1:"
           log_info_msg "           IP Address:      $IPADDR"
           log_info_msg "           Subnet Mask:     $NETMASK"
           log_info_msg "           Default Gateway: $GATEWAY"
           log_info_msg "           DNS Server:      $DNS"
        else
           log_info_msg " IP Addresss:""$IPADDR"
        fi
      fi

      log_success_msg2
   ;;

   down)
      if [ ! -e ${PIDFILE} ]; then
         log_warning_msg "\n     dhclient doesn't appear to be running on $1"
         exit 0
      fi

      log_info_msg "\n     Stopping dhclient on the $1 interface..."

      /sbin/dhclient -r -lf ${LFILE} -pf ${PIDFILE} $DHCP_STOP $1

      if [ -e ${PIDFILE} ]; then 
         ps $(cat ${PIDFILE}) | grep dhclient >/dev/null
         if [ "$?" != "0" ]; then
            rm -f ${PIDFILE}
         fi
      fi

      evaluate_retval
   ;;

   *)
      echo "Usage: $0 [interface] {up|down}"
      exit 1
   ;;
esac

# End services/dhclient

EOF
    chmod 754 $PKG/lib/services/dhclient
    mkdir -vp $PKG/etc/sysconfig
    cat > $PKG/etc/sysconfig/ifconfig.eth0 << "EOF"
ONBOOT="yes"
IFACE="eth0"
SERVICE="dhclient"
DHCP_START=""
DHCP_STOP=""

# Set PRINTIP="yes" to have the script print
# the DHCP assigned IP address
PRINTIP="no"

# Set PRINTALL="yes" to print the DHCP assigned values for
# IP, SM, DG, and 1st NS. This requires PRINTIP="yes".
PRINTALL="no"
EOF
    cat > $PKG/etc/dhcp/dhcpd.conf << "EOF"
# Begin /etc/dhcp/dhcpd.conf
#
# Example dhcpd.conf(5)
# Use this to enble / disable dynamic dns updates globally.
ddns-update-style none;
# option definitions common to all supported networks...
option domain-name "example.org";
option domain-name-servers ns1.example.org, ns2.example.org;
default-lease-time 600;
max-lease-time 7200;
# This is a very basic subnet declaration.
subnet 10.254.239.0 netmask 255.255.255.224 {
 range 10.254.239.10 10.254.239.20;
 option routers rtr-239-0-1.example.org, rtr-239-0-2.example.org;
}
# End /etc/dhcp/dhcpd.conf
EOF
    install -v -dm 755 $PKG/var/lib/dhcpd
    mkdir -vp $PKG/etc/rc.d/init.d
    cat > $PKG/etc/rc.d/init.d/dhcpd << "EOF"
#!/bin/sh
########################################################################
# Begin dhcpd
#
# Description : ISC DHCP Server Boot Script.
#
# Author      : 
#
# Version     : LFS 7.0
#
########################################################################

### BEGIN INIT INFO
# Provides:            dhcpd
# Required-Start:      network
# Required-Stop:       sendsignals
# Default-Start:       2 3 4 5
# Default-Stop:        0 2 6
# Short-Description:   Starts the ISC DHCP Server.
# X-LFS-Provided-By:   BLFS
### END INIT INFO

. /lib/lsb/init-functions

#$LastChangedBy: krejzi $
#$Date: 2013-06-11 10:49:17 -0500 (Tue, 11 Jun 2013) $

INTERFACES=""
OPTIONS=""

if [ -f "/etc/sysconfig/dhcpd" ]; then
   . /etc/sysconfig/dhcpd
fi

case "$1" in
   start)

      if [ -z "$INTERFACES" ]; then
         MSG="You need to configure dhcp server in"
         log_warning_msg "$MSG /etc/sysconfig/dhcpd"
         exit 0
      fi

      log_info_msg "Starting ISC DHCP Server dhcpd"
      start_daemon /usr/sbin/dhcpd -q $INTERFACES $OPTIONS
      evaluate_retval

      ;;

   stop)

      log_info_msg "Stopping ISC DHCP Server dhcpd"
      killproc /usr/sbin/dhcpd
      evaluate_retval

      ;;

   restart)
      $0 stop
      sleep 1
      $0 start
      ;;

   status)
      statusproc /usr/sbin/dhcpd
      ;;

   *)
      echo "Usage: $0 {start|stop|restart|status}"
      exit 1
      ;;
esac

# End /etc/init.d/dhcpd
# Begin /etc/sysconfig/dhcpd

# On which interfaces should the DHCP Server (dhcpd) serve DHCP requests?
# Separate multiple interfaces with spaces, e.g. "eth0 eth1".
INTERFACES=""

# Additional options that you want to pass to the DHCP Server Daemon?
OPTIONS=""

# End /etc/sysconfig/dhcpd
EOF
    cat > $PKG/etc/sysconfig/dhcpd << EOF

EOF
    chmod 754 $PKG/etc/rc.d/init.d/dhcpd
    chmod 644 $PKG/etc/sysconfig/dhcpd
    mkdir -vp $PKG/etc/rc.d/rc{0,1,2,3,4,5,6}.d
    ln -sf  ../init.d/dhcpd $PKG/etc/rc.d/rc0.d/K30dhcpd
    ln -sf  ../init.d/dhcpd $PKG/etc/rc.d/rc1.d/K30dhcpd
    ln -sf  ../init.d/dhcpd $PKG/etc/rc.d/rc2.d/K30dhcpd
    ln -sf  ../init.d/dhcpd $PKG/etc/rc.d/rc3.d/S30dhcpd
    ln -sf  ../init.d/dhcpd $PKG/etc/rc.d/rc4.d/S30dhcpd
    ln -sf  ../init.d/dhcpd $PKG/etc/rc.d/rc5.d/S30dhcpd
    ln -sf  ../init.d/dhcpd $PKG/etc/rc.d/rc6.d/K30dhcpd

}

function package() {
    strip -s $PKG/sbin/dhclient
    gzip -9 $PKG/usr/share/man/man?/*.?
    cd $PKG
    find . -type f -name "*"|sed 's/^.//' > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files
    find . -type d -name "*"|sed 's/^.//' >> $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files
    gzip -f $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files.gz
    mkdir -vp $PKG/install
    mv -v $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files.gz $PKG/install/
    echo -e $DESCRIPTION > $PKG/install/blfs-desc
    cat > $PKG/install/doinst.sh << "EOF"
echo -e "Non ho niente da fare!"
EOF
    tar cvvf - . --format gnu --xform 'sx^\./\(.\)x\1x' --show-stored-names --group 0 --owner 0 | gzip > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.tgz
    echo "blfs package \"$PKGNAME-$VERSION-$ARCH-$REVISION.tgz\" created."
}
build
package

if [ ! -z $URL ]; then
    cd $START && rm -vrf $PKG && rm -vrf $SRC
fi
