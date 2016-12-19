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
DESCRIPTION="\n The HarfBuzz package contains an\n OpenType text shaping engine.\n"
SECTION="general"
VERSION=1.3.2
NAME="harfbuzz"
PKGNAME=$NAME

#REC:glib2
#REC:icu
#REC:freetype2-without-harfbuzz
#OPT:cairo
#OPT:gobject-introspection
#OPT:gtk-doc
#OPT:graphite2

#LOC=""
ARCH=`uname -m`

START=`pwd`
PKG=$START/pkg
SRC=$START/work
function build() {
    mkdir -vp $PKG $SRC
    cd $SRC
    URL=http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.3.2.tar.bz2
    if [ ! -z $URL ]; then
        wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/harfbuzz/harfbuzz-1.3.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/harfbuzz/harfbuzz-1.3.2.tar.bz2 || wget -nc http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.3.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/harfbuzz/harfbuzz-1.3.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/harfbuzz/harfbuzz-1.3.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/harfbuzz/harfbuzz-1.3.2.tar.bz2
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
    ./configure --prefix=/usr --with-gobject &&
    make "-j`nproc`" || make
    make DESTDIR=$PKG install
}

function package() {
    strip -s $PKG/usr/bin/*
    #chown -R root:root usr/bin
    #gzip -9 $PKG/usr/share/man/man?/*.?
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