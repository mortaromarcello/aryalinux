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
DESCRIPTION="\n The Power Management Utilities is\n a small collection of scripts to suspend and hibernate computer\n that can be used to run user supplied scripts on suspend and\n resume.\n"
SECTION="general"
VERSION=1.4.1
NAME="pm-utils"
PKGNAME=$NAME
REVISION=1

#OPT:xmlto
#OPT:hdparm
#OPT:wireless_tools

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
    URL=http://pm-utils.freedesktop.org/releases/pm-utils-1.4.1.tar.gz
    if [ ! -z $URL ]; then
        wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pm-utils/pm-utils-1.4.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pm-utils/pm-utils-1.4.1.tar.gz || wget -nc http://pm-utils.freedesktop.org/releases/pm-utils-1.4.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pm-utils/pm-utils-1.4.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pm-utils/pm-utils-1.4.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pm-utils/pm-utils-1.4.1.tar.gz
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
    ./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/pm-utils-1.4.1 &&
    make "-j`nproc`" || make
    make DESTDIR=$PKG install
    install -v -m644 man/*.1 $PKG/usr/share/man/man1 &&
    install -v -m644 man/*.8 $PKG/usr/share/man/man8 &&
    ln -sv pm-action.8 $PKG/usr/share/man/man8/pm-suspend.8 &&
    ln -sv pm-action.8 $PKG/usr/share/man/man8/pm-hibernate.8 &&
    ln -sv pm-action.8 $PKG/usr/share/man/man8/pm-suspend-hybrid.8

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
    tar cvvf - . --format gnu --xform 'sx^\./\(.\)x\1x' --show-stored-names --group 0 --owner 0 | gzip > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.tgz
    echo "blfs package \"$PKGNAME-$VERSION-$ARCH-$REVISION.tgz\" created."
}

build
package

if [ ! -z $URL ]; then
    cd $START && rm -vrf $PKG && rm -vrf $SRC
fi
