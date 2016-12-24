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
DESCRIPTION="\n The Fontconfig package contains a\n library and support programs used for configuring and customizing\n font access.\n"
SECTION="general"
VERSION=2.12.1
NAME="fontconfig"
PKGNAME=$NAME
REVISION=1

#REQ:freetype2
#OPT:docbook-utils
#OPT:libxml2
#OPT:texlive
#OPT:tl-installer

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
    if [ -d $PKG ]; then
        rm -rvf $PKG
    fi
    if [ -d $SRC ]; then
        rm -rvf $SRC
    fi
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
    URL=http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.1.tar.bz2
    if [ ! -z $URL ]; then
        wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fontconfig/fontconfig-2.12.1.tar.bz2 || wget -nc http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fontconfig/fontconfig-2.12.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fontconfig/fontconfig-2.12.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fontconfig/fontconfig-2.12.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fontconfig/fontconfig-2.12.1.tar.bz2
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
    ./configure --prefix=/usr        \
                --sysconfdir=/etc    \
                --localstatedir=/var \
                --disable-docs       \
                --docdir=/usr/share/doc/fontconfig-2.12.1 &&
    make    "-j`nproc`" || make
    make DESTDIR=$PKG install
    mkdir -vp $PKG/usr/share/man/man1
    mkdir -vp $PKG/usr/share/man/man3
    mkdir -vp $PKG/usr/share/man/man5
    install -v -dm755 \
        $PKG/usr/share/{man/man{3,5},doc/fontconfig-2.12.1/fontconfig-devel} &&
    install -v -m644 fc-*/*.1 $PKG/usr/share/man/man1 &&
    install -v -m644 doc/*.3 $PKG/usr/share/man/man3 &&
    install -v -m644 doc/fonts-conf.5 $PKG/usr/share/man/man5 &&
    install -v -m644 doc/fontconfig-devel/* \
        $PKG/usr/share/doc/fontconfig-2.12.1/fontconfig-devel &&
    install -v -m644 doc/*.{pdf,sgml,txt,html} \
        $PKG/usr/share/doc/fontconfig-2.12.1
}

function package() {
    strip -s $PKG/usr/bin/*
    #chown -R root:root usr/bin
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
    tar cvvf - . --format gnu --xform 'sx^\./\(.\)x\1x' --show-stored-names --group 0 --owner 0 | gzip > $START/$PKGNAME-$VERSION-$ARCH$REVISION.tgz
    echo "blfs package \"$PKGNAME-$VERSION-$ARCH$REVISION.tgz\" created."
}
build
package

if [ ! -z $URL ]; then
    cd $START && rm -vrf $PKG && rm -vrf $SRC
fi
