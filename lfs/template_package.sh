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
DESCRIPTION=""
SECTION=""
VERSION=
NAME=""
PKGNAME=

#REQ:
#REC:
#OPT:

#LOC=""
#ARCH=`uname -m`

START=$SOURCE_DIR
PKG=$START/pkg
SRC=$START/work
function build() {
    mkdir -vp $PKG $SRC
    cd $SRC
    URL=
    if [ ! -z $URL ]; then
        wget 
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
    whoami > /tmp/currentuser
    # compiling package , preinstall and postinstall
    #./configure --prefix=/usr
    #make
    #make DESTDIR=$PKG install
    #
}

function package() {
    cd $PKG
    find . | xargs file | grep "executable" | grep ELF | cut -f 1 -d : \
        | xargs strip --strip-unneeded 2> /dev/null
    find . | xargs file | grep "shared object" | grep ELF | cut -f 1 -d : \
        | xargs strip --strip-unneeded 2> /dev/null
    find . | xargs file | grep "current ar archive" | cut -f 1 -d : | \
        xargs strip --strip-debug 2> /dev/null
    chown -R root:root usr/bin
    gzip -p $PKG/usr/man/man*/*
    mkdir $PKG/install
    echo $DESCRIPTION > $PKG/install/blfs-desc
    cd $PKG
    makepackage.sh $START/$PKGNAME-$VERSION-$ARCH-1.tgz
}
build
package

if [ ! -z $URL ]; then
    cd $START && rm -vrf $PKG && rm -vrf $SRC
fi
