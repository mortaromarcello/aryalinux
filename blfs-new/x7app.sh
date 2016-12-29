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
DESCRIPTION="The Xorg applications provide the expected applications available in previous X Window implementations."
SECTION="x"
VERSION=0.0.1
NAME="x7app"
PKGNAME=$NAME
REVISION=1

#REQ:libpng
#REQ:mesa
#REQ:xbitmaps
#REQ:xcb-util
#OPT:linux-pam

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
    cat > app-7.7.md5 << "EOF"
53a48e1fdfec29ab2e89f86d4b7ca902 bdftopcf-1.0.5.tar.bz2
25dab02f8e40d5b71ce29a07dc901b8c iceauth-1.0.7.tar.bz2
c4a3664e08e5a47c120ff9263ee2f20c luit-1.1.1.tar.bz2
18c429148c96c2079edda922a2b67632 mkfontdir-1.0.7.tar.bz2
9bdd6ebfa62b1bbd474906ac86a40fd8 mkfontscale-1.1.2.tar.bz2
e238c89dabc566e1835e1ecb61b605b9 sessreg-1.1.0.tar.bz2
2c47a1b8e268df73963c4eb2316b1a89 setxkbmap-1.3.1.tar.bz2
3a93d9f0859de5d8b65a68a125d48f6a smproxy-1.0.6.tar.bz2
f0b24e4d8beb622a419e8431e1c03cd7 x11perf-1.6.0.tar.bz2
7d6003f32838d5b688e2c8a131083271 xauth-1.0.9.tar.bz2
0066f23f69ca3ef62dcaeb74a87fdc48 xbacklight-1.2.1.tar.bz2
9956d751ea3ae4538c3ebd07f70736a0 xcmsdb-1.0.5.tar.bz2
b58a87e6cd7145c70346adad551dba48 xcursorgen-1.0.6.tar.bz2
8809037bd48599af55dad81c508b6b39 xdpyinfo-1.3.2.tar.bz2
fceddaeb08e32e027d12a71490665866 xdriinfo-1.0.5.tar.bz2
249bdde90f01c0d861af52dc8fec379e xev-1.2.2.tar.bz2
90b4305157c2b966d5180e2ee61262be xgamma-1.0.6.tar.bz2
f5d490738b148cb7f2fe760f40f92516 xhost-1.0.7.tar.bz2
6a889412eff2e3c1c6bb19146f6fe84c xinput-1.6.2.tar.bz2
a4d8353daf6cb0a9c47379b7413c42c6 xkbcomp-1.3.1.tar.bz2
c747faf1f78f5a5962419f8bdd066501 xkbevd-1.1.4.tar.bz2
502b14843f610af977dffc6cbf2102d5 xkbutils-1.0.4.tar.bz2
0ae6bc2a8d3af68e9c76b1a6ca5f7a78 xkill-1.0.4.tar.bz2
5dcb6e6c4b28c8d7aeb45257f5a72a7d xlsatoms-1.1.2.tar.bz2
9fbf6b174a5138a61738a42e707ad8f5 xlsclients-1.1.3.tar.bz2
2dd5ae46fa18abc9331bc26250a25005 xmessage-1.0.4.tar.bz2
723f02d3a5f98450554556205f0a9497 xmodmap-1.0.9.tar.bz2
6101f04731ffd40803df80eca274ec4b xpr-1.0.4.tar.bz2
fae3d2fda07684027a643ca783d595cc xprop-1.2.2.tar.bz2
ebffac98021b8f1dc71da0c1918e9b57 xrandr-1.5.0.tar.bz2
b54c7e3e53b4f332d41ed435433fbda0 xrdb-1.1.0.tar.bz2
a896382bc53ef3e149eaf9b13bc81d42 xrefresh-1.0.5.tar.bz2
dcd227388b57487d543cab2fd7a602d7 xset-1.2.3.tar.bz2
7211b31ec70631829ebae9460999aa0b xsetroot-1.1.1.tar.bz2
558360176b718dee3c39bc0648c0d10c xvinfo-1.1.3.tar.bz2
6b5d48464c5f366e91efd08b62b12d94 xwd-1.0.6.tar.bz2
b777bafb674555e48fd8437618270931 xwininfo-1.1.3.tar.bz2
3025b152b4f13fdffd0c46d0be587be6 xwud-1.0.4.tar.bz2
EOF
    mkdir -pv app &&
    cd app &&
    grep -v '^#' ../app-7.7.md5 | awk '{print $2}' | wget -i- -c \
        -B http://ftp.x.org/pub/individual/app/ &&
    md5sum -c ../app-7.7.md5
    for package in $(grep -v '^#' ../app-7.7.md5 | awk '{print $2}')
    do
        packagedir=${package%.tar.bz2}
        tar -xf $package
        cd $packagedir
        case $packagedir in
            luit-[0-9]* )
                line1="#ifdef _XOPEN_SOURCE"
                line2="#  undef _XOPEN_SOURCE"
                line3="#  define _XOPEN_SOURCE 600"
                line4="#endif"
                sed -i -e "s@#ifdef HAVE_CONFIG_H@$line1\n$line2\n$line3\n$line4\n\n&@" sys.c
                unset line1 line2 line3 line4
                ;;
            sessreg-* )
                sed -e 's/\$(CPP) \$(DEFS)/$(CPP) -P $(DEFS)/' -i man/Makefile.in
                ;;
        esac
        ./configure $XORG_CONFIG
        make "-j`nproc`" || make
        make DESTDIR=$PKG install
        cd $SRC/app
        rm -rf $packagedir
done
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

