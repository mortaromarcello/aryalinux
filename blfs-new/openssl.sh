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
DESCRIPTION="\n The OpenSSL package contains\n management tools and libraries relating to cryptography. These are\n useful for providing cryptography functions to other packages, such\n as OpenSSH, email applications and\n web browsers (for accessing HTTPS sites).\n"
SECTION="postlfs"
VERSION=1.0.2j
NAME="openssl"
PKGNAME=$NAME

#OPT:mitkrb

#LOC=""
ARCH=`uname -m`

START=`pwd`
PKG=$START/pkg
SRC=$START/work
function build() {
    mkdir -vp $PKG $SRC
    cd $SRC
    URL=https://openssl.org/source/openssl-1.0.2j.tar.gz
    if [ ! -z $URL ]; then
        wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openssl/openssl-1.0.2j.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openssl/openssl-1.0.2j.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openssl/openssl-1.0.2j.tar.gz || wget -nc ftp://openssl.org/source/openssl-1.0.2j.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openssl/openssl-1.0.2j.tar.gz || wget -nc https://openssl.org/source/openssl-1.0.2j.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openssl/openssl-1.0.2j.tar.gz
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
    ./config --prefix=$PKG/usr         \
         --openssldir=$PKG/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic &&
    make depend           &&
    make "-j`nproc`" || make
    sed -i 's# libcrypto.a##;s# libssl.a##' Makefile
    make MANDIR=$PKG/usr/share/man MANSUFFIX=ssl install && install -dv -m755 $PKG/usr/share/doc/openssl-1.0.2j && cp -vfr doc/* $PKG/usr/share/doc/openssl-1.0.2j
    make install
}

function package() {
    strip -s $PKG/usr/bin/openssl
    #chown -R root:root usr/bin
    #gzip -9 $PKG/usr/share/man/man?/*.?
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
