#!/bin/bash

#############################################################################
## Name:                                                                   ##
## Version:                                                                ##
## Packager: Mortaro Marcello (mortaromarcello@gmail.com)                  ##
## Homepage:                                                               ##
#############################################################################
set -e
set +h

SOURCE_ONLY=n
DESCRIPTION="\n The libxcb package provides an\n interface to the X Window System protocol, which replaces the\n current Xlib interface. Xlib can also use XCB as a transport layer,\n allowing software to make requests and receive responses with both.\n"
SECTION="x"
VERSION=1.12
NAME="libxcb"
PKGNAME=$NAME
REVISION=1

#REQ:libXau
#REQ:xcb-proto
#REC:libXdmcp
#OPT:doxygen
#OPT:check
#OPT:libxslt

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
    URL=http://xcb.freedesktop.org/dist/libxcb-1.12.tar.bz2
    if [ ! -z $URL ]; then
        wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxcb/libxcb-1.12.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libxcb/libxcb-1.12.tar.bz2 || wget -nc http://xcb.freedesktop.org/dist/libxcb-1.12.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libxcb/libxcb-1.12.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxcb/libxcb-1.12.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libxcb/libxcb-1.12.tar.bz2
        wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/libxcb-1.12-python3-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/libxcb/libxcb-1.12-python3-1.patch
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
    export XORG_PREFIX=/usr
    export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
    patch -Np1 -i ../libxcb-1.12-python3-1.patch
    sed -i "s/pthread-stubs//" configure &&
    ./configure $XORG_CONFIG      \
                --enable-xinput   \
                --without-doxygen \
                --docdir='${datadir}'/doc/libxcb-1.12 &&
    make "-j`nproc`" || make
    make DESTDIR=$PKG install
}

function package() {
    gzip -9 $PKG/usr/share/man/man?/*.?
    cd $PKG
    find . -type f -name "*"|sed 's/^.//' > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files
    find . -type d -name "*"|sed 's/^.//' >> $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files
    gzip -f $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files.gz
    mkdir -vp $PKG/install
    mv -v $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files.gz $PKG/install/
    echo -e $DESCRIPTION > $PKG/install/blfs-desc
    cat > $PKG/install/doinst.sh << "EOF"
#!/bin/sh
echo -e "Non ho niente da fare!"
EOF
    tar cvvf - . --format gnu --xform 'sx^\./\(.\)x\1x' --show-stored-names --group 0 --owner 0 | gzip > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.tgz
    echo "blfs package \"$PKGNAME-$VERSION-$ARCH-$REVISION.tgz\" created."
}
build
package

if [ ! -z $URL ]; then
    cd $START && rm -vrf $PKG && rm -vrf $SRC
fi
