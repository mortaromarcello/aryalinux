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
DESCRIPTION="The libvdpau-va-gl package contains a library which implements the VDPAU library. Libvdpau_va_gl uses OpenGL under the hood to accelerate drawing and scaling and the VA-API (if available) to accelerate video decoding. For now VA-API is available on some Intel chips, and on some AMD video adapters with the help of the libvdpau driver."
SECTION="x"
VERSION=0.4.0
NAME="libvdpau-va-gl"
PKGNAME=$NAME
REVISION=1

#REQ:cmake
#REQ:ffmpeg
#REQ:libvdpau
#REQ:libva
#OPT:doxygen
#OPT:graphviz
#OPT:tl-installer

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
    URL=https://github.com/i-rinat/libvdpau-va-gl/archive/v0.4.0.tar.gz
    if [ ! -z $URL ]; then
        wget -nc https://github.com/i-rinat/libvdpau-va-gl/archive/v0.4.0.tar.gz
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
    mkdir build &&
    cd    build &&
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$XORG_PREFIX .. &&
    make
    make DESTDIR=$PKG install
    mkdir -vp $PKG/etc/profile.d/
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
#!/bin/sh
echo "export VDPAU_DRIVER=va_gl" >> /etc/profile.d/xorg.sh
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
