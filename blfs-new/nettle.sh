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
DESCRIPTION="\n The Nettle package contains the\n low-level cryptographic library that is designed to fit easily in\n many contexts.\n"
SECTION="postlfs"
VERSION=3.3
NAME="nettle"
PKGNAME=$NAME
REVISION=1

#OPT:openssl

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
    URL=https://ftp.gnu.org/gnu/nettle/nettle-3.3.tar.gz
    if [ ! -z $URL ]; then
        wget -nc https://ftp.gnu.org/gnu/nettle/nettle-3.3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nettle/nettle-3.3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nettle/nettle-3.3.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nettle/nettle-3.3.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nettle/nettle-3.3.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/nettle/nettle-3.3.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nettle/nettle-3.3.tar.gz
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
    ./configure --prefix=/usr --disable-static &&
    make "-j`nproc`" || make
    make DESTDIR=$PKG install &&
    install -v -m755 -d $PKG/usr/share/doc/nettle-3.3 &&
    install -v -m644 nettle.html $PKG/usr/share/doc/nettle-3.3
}

function package() {
    strip -s $PKG/usr/bin/asn1{Coding,Decoding,Parser}
    cd $PKG
    find . -type f -name "*"|sed 's/^.//' > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files
    find . -type d -name "*"|sed 's/^.//' >> $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files
    gzip -f $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files.gz
    mkdir -vp $PKG/install
    mv -v $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files.gz $PKG/install/
    echo -e $DESCRIPTION > $PKG/install/blfs-desc
    cat > $PKG/install/doinst.sh << "EOF"
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
