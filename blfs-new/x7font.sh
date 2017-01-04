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
DESCRIPTION=" The Xorg font packages provide needed fonts to the Xorg applications."
SECTION="x"
VERSION=0.0.1
NAME="x7font"
PKGNAME=$NAME
REVISION=1

#REQ:xcursor-themes

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
    cat > font-7.7.md5 << "EOF"
23756dab809f9ec5011bb27fb2c3c7d6 font-util-1.3.1.tar.bz2
0f2d6546d514c5cc4ecf78a60657a5c1 encodings-1.0.4.tar.bz2
1347c3031b74c9e91dc4dfa53b12f143 font-adobe-100dpi-1.0.3.tar.bz2
6c9f26c92393c0756f3e8d614713495b font-adobe-75dpi-1.0.3.tar.bz2
66fb6de561648a6dce2755621d6aea17 font-adobe-utopia-100dpi-1.0.4.tar.bz2
e99276db3e7cef6dccc8a57bc68aeba7 font-adobe-utopia-75dpi-1.0.4.tar.bz2
fcf24554c348df3c689b91596d7f9971 font-adobe-utopia-type1-1.0.4.tar.bz2
6d25f64796fef34b53b439c2e9efa562 font-alias-1.0.3.tar.bz2
cc0726e4a277d6ed93b8e09c1f195470 font-arabic-misc-1.0.3.tar.bz2
9f11ade089d689b9d59e0f47d26f39cd font-bh-100dpi-1.0.3.tar.bz2
565494fc3b6ac08010201d79c677a7a7 font-bh-75dpi-1.0.3.tar.bz2
c8b73a53dcefe3e8d3907d3500e484a9 font-bh-lucidatypewriter-100dpi-1.0.3.tar.bz2
f6d65758ac9eb576ae49ab24c5e9019a font-bh-lucidatypewriter-75dpi-1.0.3.tar.bz2
e8ca58ea0d3726b94fe9f2c17344be60 font-bh-ttf-1.0.3.tar.bz2
53ed9a42388b7ebb689bdfc374f96a22 font-bh-type1-1.0.3.tar.bz2
6b223a54b15ecbd5a1bc52312ad790d8 font-bitstream-100dpi-1.0.3.tar.bz2
d7c0588c26fac055c0dd683fdd65ac34 font-bitstream-75dpi-1.0.3.tar.bz2
5e0c9895d69d2632e2170114f8283c11 font-bitstream-type1-1.0.3.tar.bz2
e452b94b59b9cfd49110bb49b6267fba font-cronyx-cyrillic-1.0.3.tar.bz2
3e0069d4f178a399cffe56daa95c2b63 font-cursor-misc-1.0.3.tar.bz2
0571bf77f8fab465a5454569d9989506 font-daewoo-misc-1.0.3.tar.bz2
6e7c5108f1b16d7a1c7b2c9760edd6e5 font-dec-misc-1.0.3.tar.bz2
bfb2593d2102585f45daa960f43cb3c4 font-ibm-type1-1.0.3.tar.bz2
a2401caccbdcf5698e001784dbd43f1a font-isas-misc-1.0.3.tar.bz2
cb7b57d7800fd9e28ec35d85761ed278 font-jis-misc-1.0.3.tar.bz2
143c228286fe9c920ab60e47c1b60b67 font-micro-misc-1.0.3.tar.bz2
96109d0890ad2b6b0e948525ebb0aba8 font-misc-cyrillic-1.0.3.tar.bz2
6306c808f7d7e7d660dfb3859f9091d2 font-misc-ethiopic-1.0.3.tar.bz2
e3e7b0fda650adc7eb6964ff3c486b1c font-misc-meltho-1.0.3.tar.bz2
c88eb44b3b903d79fb44b860a213e623 font-misc-misc-1.1.2.tar.bz2
56b0296e8862fc1df5cdbb4efe604e86 font-mutt-misc-1.0.3.tar.bz2
e805feb7c4f20e6bfb1118d19d972219 font-schumacher-misc-1.1.2.tar.bz2
6f3fdcf2454bf08128a651914b7948ca font-screen-cyrillic-1.0.4.tar.bz2
beef61a9b0762aba8af7b736bb961f86 font-sony-misc-1.0.3.tar.bz2
948f2e07810b4f31195185921470f68d font-sun-misc-1.0.3.tar.bz2
829a3159389b7f96f629e5388bfee67b font-winitzki-cyrillic-1.0.3.tar.bz2
3eeb3fb44690b477d510bbd8f86cf5aa font-xfree86-type1-1.0.4.tar.bz2
EOF
    mkdir -pv font &&
    cd font &&
    grep -v '^#' ../font-7.7.md5 | awk '{print $2}' | wget -i- -c \
        -B http://ftp.x.org/pub/individual/font/ &&
    md5sum -c ../font-7.7.md5
    for package in $(grep -v '^#' ../font-7.7.md5 | awk '{print $2}')
    do
        packagedir=${package%.tar.bz2}
        tar -xf $package
        cd $packagedir
        ./configure $XORG_CONFIG
        make "-j`nproc`" || make
        make DESTDIR=$PKG install
        cd $SRC/fonts
        rm -rf $packagedir
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
