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
DESCRIPTION="\n The libpng package contains\n libraries used by other programs for reading and writing PNG files.\n The PNG format was designed as a replacement for GIF and, to a\n lesser extent, TIFF, with many improvements and extensions and lack\n of patent problems.\n"
SECTION="general"
VERSION=1.6.26
NAME="libpng"
PKGNAME=$NAME

#LOC=""
ARCH=`uname -m`

START=`pwd`
PKG=$START/pkg
SRC=$START/work
function build() {
    mkdir -vp $PKG $SRC
    cd $SRC
    URL=http://downloads.sourceforge.net/libpng/libpng-1.6.26.tar.xz
    if [ ! -z $URL ]; then
        wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpng/libpng-1.6.26.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libpng/libpng-1.6.26.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpng/libpng-1.6.26.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libpng/libpng-1.6.26.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libpng/libpng-1.6.26.tar.xz || wget -nc http://downloads.sourceforge.net/libpng/libpng-1.6.26.tar.xz
        wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libpng/libpng-1.6.26-apng.patch.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libpng/libpng-1.6.26-apng.patch.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libpng/libpng-1.6.26-apng.patch.gz || wget -nc http://downloads.sourceforge.net/project/apng/libpng/libpng16/libpng-1.6.26-apng.patch.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpng/libpng-1.6.26-apng.patch.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpng/libpng-1.6.26-apng.patch.gz
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
    gzip -cd ../libpng-1.6.26-apng.patch.gz | patch -p0
    # compiling package , preinstall and postinstall
    ./configure --prefix=/usr --disable-static &&
    make "-j`nproc`" || make
    make DESTDIR=$PKG install
    mkdir -pv $PKG/usr/share/doc/libpng-1.6.26 &&
    cp -v README libpng-manual.txt $PKG/usr/share/doc/libpng-1.6.26
}

function package() {
    strip -s $PKG/usr/bin/png*
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