#!/bin/bash

#############################################################################
## Name:                                                                   ##
## Version:                                                                ##
## Packager: Mortaro Marcello (mortaromarcello@gmail.com)                  ##
## Homepage:                                                               ##
#############################################################################
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="\n The Wireless Extension (WE) is a generic API in the Linux kernel\n allowing a driver to expose configuration and statistics specific\n to common Wireless LANs to user space. A single set of tools can\n support all the variations of Wireless LANs, regardless of their\n type as long as the driver supports Wireless Extensions. WE\n parameters may also be changed on the fly without restarting the\n driver (or Linux).\n"
SECTION="basicnet"
VERSION=29
NAME="wireless_tools"
PKGNAME=$NAME

#REQ:
#REC:
#OPT:

#LOC=""
ARCH=`uname -m`

START=$SOURCE_DIR
PKG=$START/pkg
SRC=$START/work
function build() {
    mkdir -vp $PKG $SRC
    cd $SRC
    URL=http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/wireless_tools.29.tar.gz

    if [ ! -z $URL ]; then
        wget -nc http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/wireless_tools.29.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/wireless_tools/wireless_tools.29.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/wireless_tools/wireless_tools.29.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/wireless_tools/wireless_tools.29.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/wireless_tools/wireless_tools.29.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/wireless_tools/wireless_tools.29.tar.gz
        wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/wireless_tools-29-fix_iwlist_scanning-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/wireless_tools/wireless_tools-29-fix_iwlist_scanning-1.patch

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
    patch -Np1 -i ../wireless_tools-29-fix_iwlist_scanning-1.patch

    # compiling package , preinstall and postinstall
    #./configure --prefix=/usr
    #make
    #make DESTDIR=$PKG install
    #
}

function package() {
    strip -s $PKG/usr/bin/*
    #chown -R root:root usr/bin
    #gzip -9 $PKG/usr/man/man?/*.?
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
