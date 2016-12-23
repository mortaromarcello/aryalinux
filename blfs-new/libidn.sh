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
DESCRIPTION="\n libidn is a package designed for\n internationalized string handling based on the <a class=\"ulink\" \n href=\"http://www.ietf.org/rfc/rfc3454.txt\">Stringprep</a>,\n <a class=\"ulink\" href=\"http://www.ietf.org/rfc/rfc3492.txt\">Punycode</a> and <a class=\"ulink\" href=\"http://www.ietf.org/rfc/rfc3490.txt\">IDNA</a>\n specifications defined by the Internet Engineering Task Force\n (IETF) Internationalized Domain Names (IDN) working group, used for\n internationalized domain names. This is useful for converting data\n from the system's native representation into UTF-8, transforming\n Unicode strings into ASCII strings, allowing applications to use\n certain ASCII name labels (beginning with a special prefix) to\n represent non-ASCII name labels, and converting entire domain names\n to and from the ASCII Compatible Encoding (ACE) form.\n"
SECTION="general"
VERSION=1.33
NAME="libidn"
PKGNAME=$NAME

#OPT:pth
#OPT:emacs
#OPT:gtk-doc
#OPT:openjdk
#OPT:valgrind

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
    cd $PKG
    case $(uname -m) in
        x86_64)
            mkdir -vp lib
            ln -sv lib lib64
            mkdir -vp usr/lib
            ln -sv lib usr/lib64
            mkdir -vp usr/local/lib
            ln -sv lib usr/local/lib64 ;;
    esac
    cd $SRC
    URL=http://ftp.gnu.org/gnu/libidn/libidn-1.33.tar.gz
    if [ ! -z $URL ]; then
        wget -nc http://ftp.gnu.org/gnu/libidn/libidn-1.33.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libidn/libidn-1.33.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libidn/libidn-1.33.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/libidn/libidn-1.33.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libidn/libidn-1.33.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libidn/libidn-1.33.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libidn/libidn-1.33.tar.gz
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
    find doc -name "Makefile*" -delete &&
    rm -rf -v doc/{gdoc,idn.1,stamp-vti,man,texi} &&
    mkdir -pv $PKG/usr/share/doc/libidn-1.33 &&
    cp -r -v doc/* $PKG/usr/share/doc/libidn-1.33
}

function package() {
    strip -s $PKG/usr/bin/*
    gzip -9 $PKG/usr/share/man/man?/*.?
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
