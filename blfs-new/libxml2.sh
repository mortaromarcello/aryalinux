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
DESCRIPTION="\n The libxml2 package contains\n libraries and utilities used for parsing XML files.\n"
SECTION="general"
VERSION=2.9.4
NAME="libxml2"
PKGNAME=$NAME
REVISION=1

#REC:python2
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
    URL=http://xmlsoft.org/sources/libxml2-2.9.4.tar.gz
    if [ ! -z $URL ]; then
        wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libxml/libxml2-2.9.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxml/libxml2-2.9.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxml/libxml2-2.9.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libxml/libxml2-2.9.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libxml/libxml2-2.9.4.tar.gz || wget -nc http://xmlsoft.org/sources/libxml2-2.9.4.tar.gz || wget -nc ftp://xmlsoft.org/libxml2/libxml2-2.9.4.tar.gz
        wget -nc http://www.w3.org/XML/Test/xmlts20130923.tar.gz
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
    sed -i "/seems to be moved/s/^/#/" ltmain.sh &&
    ./configure --prefix=/usr --disable-static --with-history &&
    make "-j`nproc`" || make
    tar xf ../xmlts20130923.tar.gz
    make DESTDIR=$PKG install
}

function package() {
    strip -s $PKG/usr/bin/xml{catalog,lint}
    gzip -9 $PKG/usr/share/man/man?/*.?
    cd $PKG
    find . -type f -name "*"|sed 's/^.//' > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files
    find . -type d -name "*"|sed 's/^.//' >> $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files
    mkdir -vp $PKG/install
    cp -v $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files $PKG/install/
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
