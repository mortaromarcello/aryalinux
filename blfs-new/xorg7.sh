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
DESCRIPTION="Xorg is a freely redistributable, open-source implementation of the X Window System. This system provides a client/server interface between display hardware (the mouse, keyboard, and video displays) and the desktop environment, while also providing both the windowing infrastructure and a standardized application interface (API)."
SECTION="x"
VERSION=0.0.1
NAME="xorg7"
PKGNAME=$NAME
REVISION=1

#REQ:wget
#REQ:util-macros
#REQ:x7proto
#REQ:libXau
#REQ:libXdmcp
#REQ:xcb-proto
#REQ:libxcb
#REQ:x7lib
#REQ:xcb-util
#REQ:xcb-util-image
#REQ:xcb-util-keysyms
#REQ:xcb-util-renderutil
#REQ:xcb-util-wm
#REQ:xcb-util-cursor
#REQ:mesa
#REQ:xbitmaps
#REQ:x7app
#REQ:xcursor-themes
#REQ:x7font
#REQ:xkeyboard-config
#REQ:xorg-server
#REQ:x7driver
#REQ:twm
#REQ:xterm
#REQ:xclock
#REQ:xinit

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
    wget -nc http://downloads.sourceforge.net/project/dejavu/dejavu/2.37/dejavu-fonts-2.37.tar.bz2
    tar -xvf dejavu-fonts-2.37.tar.bz2
    cd dejavu-fonts-2.37
    install -v -d -m755 $PKG/usr/share/fonts/dejavu &&
    cd $SRC
    wget -nc http://downloads.sourceforge.net/project/dejavu/dejavu/2.37/dejavu-fonts-ttf-2.37.tar.bz2
    cd dejavu-fonts-ttf-2.37
    install -v -m644 ttf/*.ttf $PKG/usr/share/fonts/dejavu
    cd $SRC
    wget -nc http://downloads.sourceforge.net/project/dejavu/dejavu/2.37/dejavu-lgc-fonts-ttf-2.37.tar.bz2
    cd dejavu-lgc-fonts-ttf-2.37
    install -v -m644 ttf/*.ttf $PKG/usr/share/fonts/dejavu
    cd $SRC
    mkdir -vp $PKG/etc/X11/xorg.conf.d
    cat > $PKG/etc/X11/xorg.conf.d/xkb-defaults.conf << "EOF"
Section "InputClass"
    Identifier "XKB Defaults"
    MatchIsKeyboard "yes"
    Option "XkbOptions" "terminate:ctrl_alt_bksp"
EndSection
EOF
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
fc-cache -v /usr/share/fonts/dejavu
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
