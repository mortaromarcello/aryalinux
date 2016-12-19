#!/bin/bash

#############################################################################
## Name:                                                                   ##
## Version:                                                                ##
## Packager: Mortaro Marcello (mortaromarcello@gmail.com)                  ##
## Homepage:                                                               ##
#############################################################################
set -e
set +h

#. /etc/alps/alps.conf
#. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak libtasn1 is a highly portable C\n library that encodes and decodes DER/BER data following an ASN.1\n schema.\n"
SECTION="general"
VERSION=4.9
NAME="libtasn1"
PKGNAME=$NAME

#OPT:gtk-doc
#OPT:valgrind

#LOC=""
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
    URL=http://ftp.gnu.org/gnu/libtasn1/libtasn1-4.9.tar.gz
    if [ ! -z $URL ]; then
        wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libtasn/libtasn1-4.9.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libtasn/libtasn1-4.9.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libtasn/libtasn1-4.9.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/libtasn1/libtasn1-4.9.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libtasn/libtasn1-4.9.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libtasn/libtasn1-4.9.tar.gz || wget -nc http://ftp.gnu.org/gnu/libtasn1/libtasn1-4.9.tar.gz
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
    ./configure --prefix=/usr --disable-static &&
    make "-j`nproc`" || make
    make DESTDIR=$PKG install
    make DESTDIR=$PKG -C doc/reference install-data-local
}

function package() {
    strip -s $PKG/usr/bin/*
    #chown -R root:root usr/bin
    gzip -9 $PKG/usr/share/man/man?/*.?
    cd $PKG
    find . -type f -name "*"|sed 's/^.//' > $START/$PKGNAME-$VERSION-$ARCH-1.files
    find . -type d -name "*"|sed 's/^.//' >> $START/$PKGNAME-$VERSION-$ARCH-1.files
    mkdir -vp $PKG/install
    cp -v $START/$PKGNAME-$VERSION-$ARCH-1.files $PKG/install/
    echo -e $DESCRIPTION > $PKG/install/blfs-desc
    cat > $PKG/install/doinst.sh << "EOF"
#!/bin/sh
echo -e "Non ho niente da fare!"
EOF
    tar cvvf - . --format gnu --xform 'sx^\./\(.\)x\1x' --show-stored-names --group 0 --owner 0 | gzip > $START/$PKGNAME-$VERSION-$ARCH-1.tgz
    echo "blfs package \"$1\" created."
}
build
package

if [ ! -z $URL ]; then
    cd $START && rm -vrf $PKG && rm -vrf $SRC
fi