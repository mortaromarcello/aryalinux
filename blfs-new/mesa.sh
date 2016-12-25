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
DESCRIPTION="\n Mesa is an OpenGL compatible 3D\n graphics library.\n"
SECTION="x"
VERSION=12.0.1
NAME="mesa"
PKGNAME=$NAME
REVISION=1

#REQ:x7lib
#REQ:libdrm
#REQ:python2
#REC:elfutils
#REC:llvm
#REC:libvdpau
#OPT:libgcrypt
#OPT:nettle
#OPT:wayland
#OPT:plasma-all

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
    URL=ftp://ftp.freedesktop.org/pub/mesa/12.0.1/mesa-12.0.1.tar.xz
    if [ ! -z $URL ]; then
        wget -nc ftp://ftp.freedesktop.org/pub/mesa/12.0.1/mesa-12.0.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mesa/mesa-12.0.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mesa/mesa-12.0.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mesa/mesa-12.0.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mesa/mesa-12.0.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mesa/mesa-12.0.1.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/downloads/mesa/mesa-12.0.1-add_xdemos-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/mesa-12.0.1-add_xdemos-1.patch
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
    patch -Np1 -i ../mesa-12.0.1-add_xdemos-1.patch
    GLL_DRV="nouveau,r300,r600,radeonsi,svga,swrast,swr"
    sed -i "/pthread-stubs/d" configure.ac      &&
    sed -i "/seems to be moved/s/^/: #/" bin/ltmain.sh &&
    ./autogen.sh CFLAGS='-O2' CXXFLAGS='-O2'    \
            --prefix=$XORG_PREFIX           \
            --sysconfdir=/etc               \
            --enable-texture-float          \
            --enable-gles1                  \
            --enable-gles2                  \
            --enable-osmesa                 \
            --enable-xa                     \
            --enable-gbm                    \
            --enable-glx-tls                \
            --with-egl-platforms="drm,x11"  \
            --with-gallium-drivers=$GLL_DRV &&
    unset GLL_DRV &&
    make "-j`nproc`" || make
    make -C xdemos DEMOS_PREFIX=$XORG_PREFIX
    make DESTDIR=$PKG install
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
    tar cvvf - . --format gnu --xform 'sx^\./\(.\)x\1x' --show-stored-names --group 0 --owner 0 | gzip > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.tgz
    echo "blfs package \"$PKGNAME-$VERSION-$ARCH-$REVISION.tgz\" created."
}

build
package

if [ ! -z $URL ]; then
    cd $START && rm -vrf $PKG && rm -vrf $SRC
fi
