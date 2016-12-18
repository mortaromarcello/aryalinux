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
DESCRIPTION="\n The Wget package contains a\n utility useful for non-interactive downloading of files from the\n Web.\n"
SECTION="basicnet"
VERSION=1.18
NAME="wget"
PKGNAME=$NAME

#REC:gnutls
#OPT:libidn
#OPT:openssl
#OPT:pcre
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
    URL=http://ftp.gnu.org/gnu/wget/wget-1.18.tar.xz
    if [ ! -z $URL ]; then
        wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/wget/wget-1.18.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/wget/wget-1.18.tar.xz || wget -nc http://ftp.gnu.org/gnu/wget/wget-1.18.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/wget/wget-1.18.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/wget/wget-1.18.tar.xz || wget -nc ftp://ftp.gnu.org/gnu/wget/wget-1.18.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/wget/wget-1.18.tar.xz
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
    ./configure --prefix=/usr      \
                --sysconfdir=/etc &&
    make "-j`nproc`" || make
    make DESTDIR=$PKG install
    echo ca-directory=/etc/ssl/certs >> $PKG/etc/wgetrc
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
