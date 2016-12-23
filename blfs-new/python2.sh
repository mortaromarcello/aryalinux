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
REVISION=1

#REC:libffi
#REC:openssl
#OPT:bluez
#OPT:valgrind
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
    cat > $PKG/etc/pythonrc.py << "EOF"
# Add auto-completion and a stored history file of commands to your Python
# interactive interpreter. Requires Python 2.0+, readline. Autocomplete is
# bound to the Esc key by default (you can change it - see readline docs).
#
# Store the file in ~/.pystartup, and set an environment variable to point
# to it:  "export PYTHONSTARTUP=~/.pystartup" in bash.

import atexit
import os
import readline

historyPath = os.path.expanduser("~/.pyhistory")


def save_history(historyPath=historyPath):
    import readline
    readline.write_history_file(historyPath)

if os.path.exists(historyPath):
    readline.read_history_file(historyPath)

atexit.register(save_history)
readline.parse_and_bind("meta: complete")
del os, atexit, readline, save_history, historyPath

EOF
}

function package() {
    strip -s $PKG/usr/bin/python2.7
    cd $PKG
    find . -type f -name "*"|sed 's/^.//' > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files
    find . -type d -name "*"|sed 's/^.//' >> $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files
    gzip -f $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files.gz
    mkdir -vp $PKG/install
    mv -v $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files.gz $PKG/install/
    echo -e $DESCRIPTION > $PKG/install/blfs-desc
    cat > $PKG/install/doinst.sh << "EOF"
    export PYTHONDOCS=/usr/share/doc/python-2.7.12
EOF
    tar cvvf - . --format gnu --xform 'sx^\./\(.\)x\1x' --show-stored-names --group 0 --owner 0 | gzip > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.tgz
    echo "blfs package \"$PKGNAME-$VERSION-$ARCH-$REVISION.tgz\" created."
}
build
package

if [ ! -z $URL ]; then
    cd $START && rm -vrf $PKG && rm -vrf $SRC
fi
