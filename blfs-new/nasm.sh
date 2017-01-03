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
DESCRIPTION=" NASM (Netwide Assembler) is an 80x86 assembler designed for portability and modularity. It includes a disassembler as well."
SECTION="general"
VERSION=2.12.02
NAME="nasm"
PKGNAME=$NAME
REVISION=1

ARCH=`uname -m`

START=`pwd`
PKG=$START/pkg
SRC=$START/work

function unzip_dirname()
{
    dirname="$2-extracted"
    unzip -o -q $1 -d $dirname
    if [ "$(ls $dirname | wc -w)" == "1" ]; then
        echo "$(ls $dirname)"
    else
        echo "$dirname"
    fi
    rm -rf $dirname
}

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
    URL=http://www.nasm.us/pub/nasm/releasebuilds/2.12.02/nasm-2.12.02.tar.xz
    if [ ! -z $URL ]; then
        wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nasm/nasm-2.12.02.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nasm/nasm-2.12.02.tar.xz || wget -nc http://www.nasm.us/pub/nasm/releasebuilds/2.12.02/nasm-2.12.02.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nasm/nasm-2.12.02.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nasm/nasm-2.12.02.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nasm/nasm-2.12.02.tar.xz
        wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nasm/nasm-2.12.02-xdoc.tar.xz || wget -nc http://www.nasm.us/pub/nasm/releasebuilds/2.12.02/nasm-2.12.02-xdoc.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nasm/nasm-2.12.02-xdoc.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nasm/nasm-2.12.02-xdoc.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nasm/nasm-2.12.02-xdoc.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nasm/nasm-2.12.02-xdoc.tar.xz
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
    tar -xf ../nasm-2.12.02-xdoc.tar.xz --strip-components=1
    ./configure --prefix=$PKG/usr &&
    make "-j`nproc`" || make
    make install
    install -m755 -d $PKG/usr/share/doc/nasm-2.12.02/html &&
    cp -v doc/html/*.html $PKG/usr/share/doc/nasm-2.12.02/html &&
    cp -v doc/*.{txt,ps,pdf} $PKG/usr/share/doc/nasm-2.12.02 &&
    install -m755 -d $PKG/usr/share/info &&
    cp -v doc/info/* $PKG/usr/share/info &&
    install-info $PKG/usr/share/info/nasm.info $PKG/usr/share/info/dir
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
#!/bin/sh
echo -e "Non ho niente da fare!"
EOF
    cat > $PKG/install/$PKGNAME-$VERSION-$ARCH-$REVISION.preremove << "EOF"
#!/bin/sh
echo -e "Non ho niente da fare!"
EOF
    cat > $PKG/install/$PKGNAME-$VERSION-$ARCH-$REVISION.postremove << "EOF"
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
