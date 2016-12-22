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
DESCRIPTION="\n The Desktop File Utils package\n contains command line utilities for working with <a class=\"ulink\" \n href=\"http://standards.freedesktop.org/desktop-entry-spec/latest/\">Desktop\n entries</a>. These utilities are used by Desktop Environments and\n other applications to manipulate the MIME-types application\n databases and help adhere to the Desktop Entry Specification.\n"
SECTION="general"
VERSION=0,23
NAME="desktop-file-utils"
PKGNAME=$NAME

#REQ:glib2
#OPT:emacs

#LOC=""
ARCH=`uname -m`

START=`pwd`
PKG=$START/pkg
SRC=$START/work
function build() {
    mkdir -vp $PKG $SRC
    cd $SRC
    URL=http://freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.23.tar.xz
    if [ ! -z $URL ]; then
        wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/desktop-file-utils/desktop-file-utils-0.23.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/desktop-file-utils/desktop-file-utils-0.23.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/desktop-file-utils/desktop-file-utils-0.23.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/desktop-file-utils/desktop-file-utils-0.23.tar.xz || wget -nc http://freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.23.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/desktop-file-utils/desktop-file-utils-0.23.tar.xz
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
    # compiling package , preinstall and postinstall
    ./configure --prefix=/usr && make "-j`nproc`" || make
    make DESTDIR=$PKG install
}

function package() {
    strip -s $PKG/usr/bin/*
    #chown -R root:root usr/bin
    #gzip -9 $PKG/usr/share/man/man?/*.?
    cd $PKG
    find . -type f -name "*"|sed 's/^.//' > $START/$PKGNAME-$VERSION-$ARCH-1.files
    find . -type d -name "*"|sed 's/^.//' >> $START/$PKGNAME-$VERSION-$ARCH-1.files
    mkdir $PKG/install
    echo -e $DESCRIPTION > $PKG/install/blfs-desc
    tar cvvf - . --format gnu --xform 'sx^\./\(.\)x\1x' --show-stored-names --group 0 --owner 0 | gzip > $START/$PKGNAME-$VERSION-$ARCH-1.tgz
    echo "blfs package \"$PKGNAME-$VERSION-$ARCH-1.tgz\" created."
}
build
package

if [ ! -z $URL ]; then
    cd $START && rm -vrf $PKG && rm -vrf $SRC
fi
