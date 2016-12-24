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
DESCRIPTION="\n Even though D-Bus was built in\n LFS, there are some features provided by the package that other\n BLFS packages need, but their dependencies didn't fit into LFS.\n"
SECTION="general"
VERSION=1.10.10
NAME="dbus"
PKGNAME=$NAME
REVISION=1

#REC:x7lib
#OPT:dbus-glib
#OPT:python-modules#dbus-python
#OPT:python-modules#pygobject2
#OPT:valgrind
#OPT:doxygen
#OPT:xmlto

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
    URL=http://dbus.freedesktop.org/releases/dbus/dbus-1.10.10.tar.gz
    if [ ! -z $URL ]; then
        wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/db/dbus-1.10.10.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/db/dbus-1.10.10.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/db/dbus-1.10.10.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/db/dbus-1.10.10.tar.gz || wget -nc http://dbus.freedesktop.org/releases/dbus/dbus-1.10.10.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/db/dbus-1.10.10.tar.gz
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
    ./configure --prefix=/usr                  \
                --sysconfdir=/etc              \
                --localstatedir=/var           \
                --disable-doxygen-docs         \
                --disable-xml-docs             \
                --disable-static               \
                --disable-systemd              \
                --without-systemdsystemunitdir \
                --with-console-auth-dir=/run/console/ \
                --docdir=/usr/share/doc/dbus-1.10.10   &&
    make "-j`nproc`" || make
    make DESTDIR=$PKG install
}

function package() {
    strip -s $PKG/usr/bin/*
    cd $PKG
    find . -type f -name "*"|sed 's/^.//' > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files
    find . -type d -name "*"|sed 's/^.//' >> $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files
    gzip -f $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files.gz
    mkdir -vp $PKG/install
    mv -v $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files.gz $PKG/install/
    echo -e $DESCRIPTION > $PKG/install/blfs-desc
    cat > $PKG/install/doinst.sh << "EOF"
#!/bin/sh
if getent group messagebus
then
    echo "group messagebus exist"
else
    groupadd -g 18 messagebus
fi
if getent passwd messagebus
then
    echo "user messagebus exist"
else
    useradd -c "D-Bus Message Daemon User" -d /var/run/dbus \
        -u 18 -g messagebus -s /bin/false messagebus
fi
EOF
    tar cvvf - . --format gnu --xform 'sx^\./\(.\)x\1x' --show-stored-names --group 0 --owner 0 | gzip > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.tgz
    echo "blfs package \"$PKGNAME-$VERSION-$ARCH-$REVISION.tgz\" created."
}
build
package

if [ ! -z $URL ]; then
    cd $START && rm -vrf $PKG && rm -vrf $SRC
fi
