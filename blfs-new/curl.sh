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
DESCRIPTION=" The cURL package contains an utility and a library used for transferring files with URL syntax to any of the following protocols: FTP, FTPS, HTTP, HTTPS, SCP, SFTP, TFTP, TELNET, DICT, LDAP, LDAPS and FILE. Its ability to both download and upload files can be incorporated into other programs to support functions like streaming media."
SECTION="basicnet"
VERSION=7.50.3
NAME="curl"
PKGNAME=$NAME
REVISION=1

#REC:cacerts
#REC:openssl
#REC:gnutls
#OPT:libidn
#OPT:mitkrb
#OPT:nghttp2
#OPT:openldap
#OPT:samba
#OPT:stunnel
#OPT:valgrind

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
    URL=https://curl.haxx.se/download/curl-7.50.3.tar.lzma
    if [ ! -z $URL ]; then
        wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/curl/curl-7.50.3.tar.lzma || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/curl/curl-7.50.3.tar.lzma || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/curl/curl-7.50.3.tar.lzma || wget -nc https://curl.haxx.se/download/curl-7.50.3.tar.lzma || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/curl/curl-7.50.3.tar.lzma || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/curl/curl-7.50.3.tar.lzma
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
    ./configure --prefix=/usr              \
                --disable-static           \
                --enable-threaded-resolver &&
    make "-j`nproc`" || make
    make DESTDIR=$PKG install &&
    rm -rf docs/examples/.deps &&
    find docs \( -name Makefile\* \
            -o -name \*.1       \
            -o -name \*.3 \)    \
            -exec rm {} \;      &&
    install -v -d -m755 $PKG/usr/share/doc/curl-7.50.3 &&
    cp -v -R docs/*     $PKG/usr/share/doc/curl-7.50.3
}

function package() {
    strip -s $PKG/usr/bin/curl
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
