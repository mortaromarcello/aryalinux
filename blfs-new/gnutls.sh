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
DESCRIPTION="\n The GnuTLS package contains\n libraries and userspace tools which provide a secure layer over a\n reliable transport layer. Currently the GnuTLS library implements the proposed\n standards by the IETF's TLS working group. Quoting from the TLS\n protocol specification:\n"
SECTION="postlfs"
VERSION=3.5.5
NAME="gnutls"
PKGNAME=$NAME
REVISION=1

#REQ:nettle
#REC:cacerts
#REC:libtasn1
#REC:p11-kit
#OPT:doxygen
#OPT:gtk-doc
#OPT:guile
#OPT:libidn
#OPT:net-tools
#OPT:texlive
#OPT:tl-installer
#OPT:unbound
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
    cd $SRC
    URL=ftp://ftp.gnutls.org/gcrypt/gnutls/v3.5/gnutls-3.5.5.tar.xz
    if [ ! -z $URL ]; then
        wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnutls/gnutls-3.5.5.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnutls/gnutls-3.5.5.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnutls/gnutls-3.5.5.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnutls/gnutls-3.5.5.tar.xz || wget -nc ftp://ftp.gnutls.org/gcrypt/gnutls/v3.5/gnutls-3.5.5.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnutls/gnutls-3.5.5.tar.xz
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
    # compiling package , preinstall and postinstall
    ./configure --prefix=/usr \
        --with-default-trust-store-file=/etc/ssl/ca-bundle.crt &&
    make "-j`nproc`" || make
    make DESTDIR=$PKG install
    make DESTDIR=$PKG -C doc/reference install-data-local
}

function package() {
    strip -s $PKG/usr/bin/*
    #chown -R root:root usr/bin
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
