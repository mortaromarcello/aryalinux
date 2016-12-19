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
DESCRIPTION="\n The xcb-proto package provides the\n XML-XCB protocol descriptions that libxcb uses to generate the majority of its\n code and API.\n"
SECTION="x"
VERSION=1.12
NAME="xcb-proto"
PKGNAME=$NAME

#REQ:python2
#OPT:libxml2

#LOC=""
ARCH=`uname -m`

START=`pwd`
PKG=$START/pkg
SRC=$START/work

function unzip_file()
{
	dir_name=$(unzip_dirname $1 $2)
	echo $dir_name
	if [ `echo $dir_name | grep "extracted$"` ]
	then
		echo "Create and extract..."
		mkdir $dir_name
		cp $1 $dir_name
		cd $dir_name
		unzip $1
		cd ..
	else
		echo "Just Extract..."
		unzip $1
	fi
}
function build() {
    mkdir -vp $PKG $SRC
    cd $SRC
    URL=http://xcb.freedesktop.org/dist/xcb-proto-1.12.tar.bz2
    if [ ! -z $URL ]; then
        wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xcb-proto/xcb-proto-1.12.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xcb-proto/xcb-proto-1.12.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xcb-proto/xcb-proto-1.12.tar.bz2 || wget -nc http://xcb.freedesktop.org/dist/xcb-proto-1.12.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xcb-proto/xcb-proto-1.12.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xcb-proto/xcb-proto-1.12.tar.bz2
        wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/xcb-proto-1.12-python3-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/xcb-proto/xcb-proto-1.12-python3-1.patch
        wget -nc http://www.linuxfromscratch.org/patches/downloads/xcb-proto/xcb-proto-1.12-schema-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/xcb-proto-1.12-schema-1.patch
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
    export XORG_PREFIX=/usr
    export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
    patch -Np1 -i ../xcb-proto-1.12-schema-1.patch
    patch -Np1 -i ../xcb-proto-1.12-python3-1.patch
    ./configure $XORG_CONFIG
    make DESTDIR=$PKG install
}

function package() {
    #strip -s $PKG/usr/bin/*
    #chown -R root:root usr/bin
    #gzip -9 $PKG/usr/share/man/man?/*.?
    cd $PKG
    find . -type f -name "*"|sed 's/^.//' > $START/$PKGNAME-$VERSION-$ARCH-1.files
    find . -type d -name "*"|sed 's/^.//' >> $START/$PKGNAME-$VERSION-$ARCH-1.files
    mkdir -vp $PKG/install
    cp -v $START/$PKGNAME-$VERSION-$ARCH-1.files $PKG/install/
    echo -e $DESCRIPTION > $PKG/install/blfs-desc
    cat > $PKG/install/doinst.sh << "EOF"
#!/bin/sh
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