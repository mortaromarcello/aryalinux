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
DESCRIPTION=" The Xorg protocol headers provide the header files required to build the system, and to allow other applications to build against the installed X Window system."
SECTION="x"
VERSION=
NAME="x7proto"
PKGNAME=$NAME
REVISION=1

#REQ:util-macros
#REC:wget
#OPT:fop
#OPT:libxslt
#OPT:xmlto
#OPT:asciidoc

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
    URL=
    if [ ! -z $URL ]; then
        wget 
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

    cat > proto-7.7.md5 << "EOF"
1a05fb01fa1d5198894c931cf925c025 bigreqsproto-1.1.2.tar.bz2
98482f65ba1e74a08bf5b056a4031ef0 compositeproto-0.4.2.tar.bz2
998e5904764b82642cc63d97b4ba9e95 damageproto-1.2.1.tar.bz2
4ee175bbd44d05c34d43bb129be5098a dmxproto-2.3.1.tar.bz2
b2721d5d24c04d9980a0c6540cb5396a dri2proto-2.8.tar.bz2
a3d2cbe60a9ca1bf3aea6c93c817fee3 dri3proto-1.0.tar.bz2
e7431ab84d37b2678af71e29355e101d fixesproto-5.0.tar.bz2
36934d00b00555eaacde9f091f392f97 fontsproto-2.1.3.tar.bz2
5565f1b0facf4a59c2778229c1f70d10 glproto-1.4.17.tar.bz2
b290a463af7def483e6e190de460f31a inputproto-2.3.2.tar.bz2
94afc90c1f7bef4a27fdd59ece39c878 kbproto-1.0.7.tar.bz2
2d569c75884455c7148d133d341e8fd6 presentproto-1.0.tar.bz2
a46765c8dcacb7114c821baf0df1e797 randrproto-1.5.0.tar.bz2
1b4e5dede5ea51906f1530ca1e21d216 recordproto-1.14.2.tar.bz2
a914ccc1de66ddeb4b611c6b0686e274 renderproto-0.11.1.tar.bz2
cfdb57dae221b71b2703f8e2980eaaf4 resourceproto-1.2.0.tar.bz2
edd8a73775e8ece1d69515dd17767bfb scrnsaverproto-1.2.2.tar.bz2
fe86de8ea3eb53b5a8f52956c5cd3174 videoproto-2.3.3.tar.bz2
5f4847c78e41b801982c8a5e06365b24 xcmiscproto-1.2.2.tar.bz2
70c90f313b4b0851758ef77b95019584 xextproto-7.3.0.tar.bz2
120e226ede5a4687b25dd357cc9b8efe xf86bigfontproto-1.2.0.tar.bz2
a036dc2fcbf052ec10621fd48b68dbb1 xf86dgaproto-2.1.tar.bz2
1d716d0dac3b664e5ee20c69d34bc10e xf86driproto-2.1.1.tar.bz2
e793ecefeaecfeabd1aed6a01095174e xf86vidmodeproto-2.3.1.tar.bz2
9959fe0bfb22a0e7260433b8d199590a xineramaproto-1.2.1.tar.bz2
16791f7ca8c51a20608af11702e51083 xproto-7.0.31.tar.bz2
EOF
    mkdir -pv proto &&
    cd proto &&
    grep -v '^#' ../proto-7.7.md5 | awk '{print $2}' | wget -i- -c \
        -B http://ftp.x.org/pub/individual/proto/ &&
    md5sum -c ../proto-7.7.md5
    for package in $(grep -v '^#' ../proto-7.7.md5 | awk '{print $2}')
    do
        packagedir=${package%.tar.bz2}
        tar -xvf $package
        cd $packagedir
        ./configure $XORG_CONFIG
        make DESTDIR=$PKG install
        cd $SRC/proto
        rm -rvf $packagedir
    done
}

function package() {
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
