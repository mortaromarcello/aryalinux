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
DESCRIPTION="\n The Python 2 package contains the\n Python development environment. It\n is useful for object-oriented programming, writing scripts,\n prototyping large programs or developing entire applications. This\n version is for backward compatibility with other dependent\n packages.\n"
SECTION="general"
VERSION=2.7.12
NAME="python2"
PKGNAME=$NAME

#REC:libffi
#OPT:bluez
#OPT:valgrind
#OPT:openssl
#OPT:sqlite
#OPT:tk

#LOC=""
ARCH=`uname -m`

START=`pwd`
PKG=$START/pkg
SRC=$START/work
function build() {
    mkdir -vp $PKG $SRC
    cd $SRC
    URL=https://www.python.org/ftp/python/2.7.12/Python-2.7.12.tar.xz
    if [ ! -z $URL ]; then
        wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/Python/Python-2.7.12.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/Python/Python-2.7.12.tar.xz || wget -nc https://www.python.org/ftp/python/2.7.12/Python-2.7.12.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/Python/Python-2.7.12.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/Python/Python-2.7.12.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/Python/Python-2.7.12.tar.xz
        wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/Python/python-2.7.12-docs-html.tar.bz2 || wget -nc https://docs.python.org/2.7/archives/python-2.7.12-docs-html.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/Python/python-2.7.12-docs-html.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/Python/python-2.7.12-docs-html.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/Python/python-2.7.12-docs-html.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/Python/python-2.7.12-docs-html.tar.bz2
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
    ./configure --prefix=/usr       \
                --enable-shared     \
                --with-system-expat \
                --with-system-ffi   \
                --enable-unicode=ucs4 &&
    make "-j`nproc`" || make
    make DESTDIR=$PKG install &&
    chmod -v 755 $PKG/usr/lib/libpython2.7.so.1.0
    install -v -dm755 $PKG/usr/share/doc/python-2.7.12 &&
    tar --strip-components=1                     \
        --no-same-owner                          \
        --directory $PKG/usr/share/doc/python-2.7.12 \
        -xvf ../python-2.7.12-docs-html.tar.bz2 &&
    find $PKG/usr/share/doc/python-2.7.12 -type d -exec chmod 0755 {} \; &&
    find $PKG/usr/share/doc/python-2.7.12 -type f -exec chmod 0644 {} \;
}

function package() {
    strip -s $PKG/usr/bin/python2.7
    #chown -R root:root usr/bin
    #gzip -9 $PKG/usr/share/man/man?/*.?
    cd $PKG
    find . -type f -name "*"|sed 's/^.//' > $START/$PKGNAME-$VERSION-$ARCH-1.files
    find . -type d -name "*"|sed 's/^.//' >> $START/$PKGNAME-$VERSION-$ARCH-1.files
    mkdir -vp $PKG/install
    cp -v $START/$PKGNAME-$VERSION-$ARCH-1.files $PKG/install/
    echo -e $DESCRIPTION > $PKG/install/blfs-desc
    cat > $PKG/install/doinst.sh << "EOF"
    export PYTHONDOCS=/usr/share/doc/python-2.7.12
EOF
    tar cvvf - . --format gnu --xform 'sx^\./\(.\)x\1x' --show-stored-names --group 0 --owner 0 | gzip > $START/$PKGNAME-$VERSION-$ARCH-1.tgz
    echo "blfs package \"$PKGNAME-$VERSION-$ARCH-1.tgz\" created."
}
build
package

if [ ! -z $URL ]; then
    cd $START && rm -vrf $PKG && rm -vrf $SRC
fi
