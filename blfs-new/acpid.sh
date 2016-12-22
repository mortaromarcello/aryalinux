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
DESCRIPTION="\nThe acpid (Advanced Configuration and Power Interface\n event daemon) is a completely flexible, totally\n extensible daemon for delivering ACPI events. It listens on netlin\n interface and when an event occurs, executes programs to handle the\n event. The programs it executes are configured through a set of\n configuration files, which can be dropped into place by packages or\n by the user.\n"
SECTION="general"
VERSION=2.0.28
NAME="acpid"
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
    cd $SRC
    URL=http://downloads.sourceforge.net/acpid2/acpid-2.0.28.tar.xz
    if [ ! -z $URL ]; then
        wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/acpid/acpid-2.0.28.tar.xz || wget -nc http://downloads.sourceforge.net/acpid2/acpid-2.0.28.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/acpid/acpid-2.0.28.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/acpid/acpid-2.0.28.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/acpid/acpid-2.0.28.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/acpid/acpid-2.0.28.tar.xz
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
    ./configure --prefix=/usr \
        --docdir=/usr/share/doc/acpid-2.0.28 &&
    make "-j`nproc`" || make
    make DESTDIR=$PKG install
    mkdir -vp $PKG/etc/acpi/events
    cat > $PKG/etc/acpi/events/lid << "EOF"
event=button/lid
action=/etc/acpi/lid.sh
EOF
cat > $PKG/etc/acpi/lid.sh << "EOF"
#!/bin/sh
/bin/grep -q open /proc/acpi/button/lid/LID/state && exit 0
/usr/sbin/pm-suspend
EOF

    chmod +x $PKG/etc/acpi/lid.sh
    mkdir -vp -m 755 $PKG/etc/rc.d/rc{0,1,2,3,4,5,6,S}.d
    mkdir -vp -m 755 $PKG/etc/rc.d/init.d
    mkdir -vp -m 755 $PKG/etc/sysconfig
    cat > $PKG/etc/rc.d/init.d/acpid << "EOF"
#!/bin/sh
########################################################################
# Begin acpid
#
# Description : ACPI event daemon boot script
#
# Author      : Igor Živković <contact@igor-zivkovic.from.hr>
#
# Version     : BLFS SVN
#
########################################################################

### BEGIN INIT INFO
# Provides:            acpid
# Required-Start:      $remote_fs $syslog
# Required-Stop:       $remote_fs $syslog
# Default-Start:       2 3 4 5
# Default-Stop:        0 1 6
# Short-Description:   Starts Advanced Configuration and Power Interface event daemon
# X-LFS-Provided-By:   BLFS
### END INIT INFO

. /lib/lsb/init-functions

#$LastChangedBy: igor $
#$Date: 2013-07-10 17:04:20 -0500 (Wed, 10 Jul 2013) $

case "$1" in
   start)
      log_info_msg "Starting ACPI event daemon..."
      start_daemon /usr/sbin/acpid
      sleep 1
      pidofproc -p "/run/acpid.pid" > /dev/null
      evaluate_retval
      ;;

   stop)
      log_info_msg "Stopping ACPI event daemon..."
      killproc -p "/run/acpid.pid" /usr/sbin/acpid
      evaluate_retval
      ;;

   restart)
      $0 stop
      sleep 1
      $0 start
      ;;

   status)
      statusproc /usr/sbin/acpid
      ;;

   *)
      echo "Usage: $0 {start|stop|restart|status}"
      exit 1
      ;;
esac

# End acpid

EOF
    chmod 754 $PKG/etc/rc.d/init.d/acpid
    ln -svf  ../init.d/acpid $PKG/etc/rc.d/rc0.d/K32acpid
    ln -svf  ../init.d/acpid $PKG/etc/rc.d/rc1.d/K32acpid
    ln -svf  ../init.d/acpid $PKG/etc/rc.d/rc2.d/S18acpid
    ln -svf  ../init.d/acpid $PKG/etc/rc.d/rc3.d/S18acpid
    ln -svf  ../init.d/acpid $PKG/etc/rc.d/rc4.d/S18acpid
    ln -svf  ../init.d/acpid $PKG/etc/rc.d/rc5.d/S18acpid
    ln -svf  ../init.d/acpid $PKG/etc/rc.d/rc6.d/K32acpid
}

function package() {
    strip -s $PKG/usr/bin/*
    gzip -9 $PKG/usr/share/man/man?/*.?
    cd $PKG
    find . -type f -name "*"|sed 's/^.//' > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files
    find . -type d -name "*"|sed 's/^.//' >> $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files
    gzip -f $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files.gz
    mkdir -vp $PKG/install
    mv -v $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files.gz $PKG/install/
    echo -e $DESCRIPTION > $PKG/install/blfs-desc
    tar cvvf - . --format gnu --xform 'sx^\./\(.\)x\1x' --show-stored-names --group 0 --owner 0 | gzip > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.tgz
    echo "blfs package \"$PKGNAME-$VERSION-$ARCH-$REVISION.tgz\" created."
}

build
package

if [ ! -z $URL ]; then
    cd $START && rm -vrf $PKG && rm -vrf $SRC
fi
