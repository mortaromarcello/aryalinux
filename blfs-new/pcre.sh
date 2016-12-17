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
DESCRIPTION="\n The PCRE package contains\n Perl Compatible Regular Expression\n libraries. These are useful for implementing regular expression\n pattern matching using the same syntax and semantics as\n Perl 5.\n"
SECTION="general"
VERSION=8.39
NAME="pcre"
PKGNAME=$NAME

#OPT:valgrind

#LOC=""
ARCH=`uname -m`

START=`pwd`
PKG=$START/pkg
SRC=$START/work
function build() {
    mkdir -vp $PKG $SRC
    cd $SRC
    URL=ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.bz2
    if [ ! -z $URL ]; then
        wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pcre/pcre-8.39.tar.bz2 || wget -nc ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pcre/pcre-8.39.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pcre/pcre-8.39.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pcre/pcre-8.39.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pcre/pcre-8.39.tar.bz2
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
    ./configure --prefix=/usr                     \
                --docdir=/usr/share/doc/pcre-8.39 \
                --enable-unicode-properties       \
                --enable-pcre16                   \
                --enable-pcre32                   \
                --enable-pcregrep-libz            \
                --enable-pcregrep-libbz2          \
                --enable-pcretest-libreadline     \
                --disable-static                 &&
    make "-j`nproc`" || make
    make DESTDIR=$PKG install
    mkdir -vp $PKG/lib
    mv -v $PKG/usr/lib/libpcre.so.* $PKG/lib &&
    ln -sfv ../../lib/$(readlink $PKG/usr/lib/libpcre.so) $PKG/usr/lib/libpcre.so

    # compiling package , preinstall and postinstall
    #./configure --prefix=/usr
    #make
    #make DESTDIR=$PKG install
    #
}

function package() {
    strip -s $PKG/usr/bin/pcre{grep,test}
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
