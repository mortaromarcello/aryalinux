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
DESCRIPTION="\n The Sudo package allows a system\n administrator to give certain users (or groups of users) the\n ability to run some (or all) commands as <code class=\"systemitem\">root or another user while logging the commands\n and arguments.\n"
SECTION="postlfs"
VERSION=1
NAME="sudo"
PKGNAME=$NAME

#OPT:linux-pam
#OPT:mitkrb
#OPT:openldap

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
    URL=http://www.sudo.ws/dist/sudo-1.8.18p1.tar.gz
    if [ ! -z $URL ]; then
        wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sudo/sudo-1.8.18p1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sudo/sudo-1.8.18p1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sudo/sudo-1.8.18p1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sudo/sudo-1.8.18p1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sudo/sudo-1.8.18p1.tar.gz || wget -nc http://www.sudo.ws/dist/sudo-1.8.18p1.tar.gz || wget -nc ftp://ftp.sudo.ws/pub/sudo/sudo-1.8.18p1.tar.gz
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
    ./configure --prefix=/usr              \
            --libexecdir=/usr/lib      \
            --with-secure-path         \
            --with-all-insults         \
            --with-env-editor          \
            --docdir=/usr/share/doc/sudo-1.8.18p1 \
            --with-passprompt="[sudo] password for %p" &&
    make "-j`nproc`" || make
    make DESTDIR=$PKG install &&
    ln -sfv libsudo_util.so.0.0.0 $PKG/usr/lib/sudo/libsudo_util.so.0
    cat > $PKG/etc/pam.d/sudo << "EOF"
# Begin /etc/pam.d/sudo
# include the default auth settings
auth include system-auth
# include the default account settings
account include system-account
# Set default environment variables for the service user
session required pam_env.so
# include system session defaults
session include system-session
# End /etc/pam.d/sudo
EOF
chmod 644 $PKG/etc/pam.d/sudo
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
echo -e "Non ho niente da fare!"
EOF
    tar cvvf - . --format gnu --xform 'sx^\./\(.\)x\1x' --show-stored-names --group 0 --owner 0 | gzip > $START/$PKGNAME-$VERSION-$ARCH-1.tgz
    echo "blfs package \"$PKGNAME-$VERSION-$ARCH-1.tgz\" created."
}
build
package

if [ ! -z $URL ]; then
    cd $START && rm -vrf $PKG && rm -vrf $SRC
fi
