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
DESCRIPTION="\n The GLib package contains\n low-level libraries useful for providing data structure handling\n for C, portability wrappers and interfaces for such runtime\n functionality as an event loop, threads, dynamic loading and an\n object system.\n"
SECTION="general"
VERSION=2.50.0
NAME="glib2"
PKGNAME=$NAME

#REQ:libffi
#REQ:python2
#REC:pcre
#OPT:dbus
#OPT:elfutils
#OPT:gtk-doc
#OPT:shared-mime-info
#OPT:desktop-file-utils

#LOC=""
ARCH=`uname -m`

START=`pwd`
PKG=$START/pkg
SRC=$START/work
function build() {
    mkdir -vp $PKG $SRC
    cd $SRC
    URL=http://ftp.gnome.org/pub/gnome/sources/glib/2.50/glib-2.50.0.tar.xz
    if [ ! -z $URL ]; then
        wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/glib/glib-2.50.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/glib/glib-2.50.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/glib/glib-2.50.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/glib/glib-2.50.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/glib/2.50/glib-2.50.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/glib/glib-2.50.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/glib/2.50/glib-2.50.0.tar.xz
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
    ./configure --prefix=/usr --with-pcre=system &&
    make "-j`nproc`" || make
    make DESTDIR=$PKG install
}

function package() {
    strip -s $PKG/usr/bin/{gapplication,gdbus}
    strip -s $PKG/usr/bin/gio*
    strip -s $PKG/usr/bin/glib-{compile-*,genmarshal}
    strip -s $PKG/usr/bin/{gobject-query,gresource,gsettings,gtester}
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
