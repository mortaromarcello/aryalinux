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
DESCRIPTION="\n The International Components for\n Unicode (ICU) package is a mature, widely used set of C/C++\n libraries providing Unicode and Globalization support for software\n applications. ICU is widely\n portable and gives applications the same results on all platforms.\n"
SECTION="general"
VERSION=58_1
NAME="icu"
PKGNAME=$NAME

#OPT:llvm
#OPT:doxygen

#LOC=""
ARCH=`uname -m`

START=`pwd`
PKG=$START/pkg
SRC=$START/work
function build() {
    mkdir -vp $PKG $SRC
    cd $SRC
    URL=http://download.icu-project.org/files/icu4c/58.1/icu4c-58_1-src.tgz
    if [ ! -z $URL ]; then
        wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/icu/icu4c-58_1-src.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/icu/icu4c-58_1-src.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/icu/icu4c-58_1-src.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/icu/icu4c-58_1-src.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/icu/icu4c-58_1-src.tgz || wget -nc http://download.icu-project.org/files/icu4c/58.1/icu4c-58_1-src.tgz
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
    #whoami > /tmp/currentuser
    # compiling package , preinstall and postinstall
    cd source &&
    ./configure --prefix=/usr &&
    make "-j`nproc`" || make
    make DESTDIR=$PKG install
}

function package() {
    strip -s $PKG/usr/bin/{derb,gen*,icuinfo,makeconv,pkgdata,uconv}
    strip -s $PKG/usr/sbin/*
    #chown -R root:root usr/bin
    gzip -9 $PKG/usr/share/man/man?/*.?
    cd $PKG
    find . -type f -name "*"|sed 's/^.//' > $START/$PKGNAME-$VERSION-$ARCH-1.files
    find . -type d -name "*"|sed 's/^.//' >> $START/$PKGNAME-$VERSION-$ARCH-1.files
    mkdir -vp $PKG/install
    cp -v $START/$PKGNAME-$VERSION-$ARCH-1.files $PKG/install/
    echo -e $DESCRIPTION > $PKG/install/blfs-desc
    cat > $PKG/install/doinst.sh << "EOF"
echo -e "Non ho niente da fare!"
EOF
    tar cvvf - . --format gnu --xform 'sx^\./\(.\)x\1x' --show-stored-names --group 0 --owner 0 | gzip > $START/$PKGNAME-$VERSION-$ARCH-1.tgz
    echo "blfs package \"$1\" created."
}
build
package

if [ ! -z $URL ]; then
    cd $START && rm -vrf $PKG && rm -vrf $SRC
fi
