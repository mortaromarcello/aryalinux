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
DESCRIPTION="\n Git is a free and open source,\n distributed version control system designed to handle everything\n from small to very large projects with speed and efficiency. Every\n Git clone is a full-fledged\n repository with complete history and full revision tracking\n capabilities, not dependent on network access or a central server.\n Branching and merging are fast and easy to do. Git is used for version control of files, much\n like tools such as <a class=\"xref\" href=\"mercurial.html\" title=\"Mercurial-3.9.2\">Mercurial-3.9.2</a>, Bazaar, <a class=\"xref\" href=\"subversion.html\" \n title=\"Subversion-1.9.4\">Subversion-1.9.4</a>, <a class=\"ulink\" \n href=\"http://www.nongnu.org/cvs/\">CVS</a>, Perforce, and Team\n Foundation Server.\n"
SECTION="general"
VERSION=2.10.1
NAME="git"
PKGNAME=$NAME
REVISION=1

#REC:curl
#REC:openssl
#REC:python2
#OPT:pcre
#OPT:subversion
#OPT:tk
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
    URL=https://www.kernel.org/pub/software/scm/git/git-2.10.1.tar.xz
    if [ ! -z $URL ]; then
        wget -nc https://www.kernel.org/pub/software/scm/git/git-2.10.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/git/git-2.10.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/git/git-2.10.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/git/git-2.10.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/git/git-2.10.1.tar.xz || wget -nc ftp://ftp.kernel.org/pub/software/scm/git/git-2.10.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/git/git-2.10.1.tar.xz
        wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/git/git-manpages-2.10.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/git/git-manpages-2.10.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/git/git-manpages-2.10.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/git/git-manpages-2.10.1.tar.xz || wget -nc https://www.kernel.org/pub/software/scm/git/git-manpages-2.10.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/git/git-manpages-2.10.1.tar.xz
        wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/git/git-htmldocs-2.10.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/git/git-htmldocs-2.10.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/git/git-htmldocs-2.10.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/git/git-htmldocs-2.10.1.tar.xz || wget -nc https://www.kernel.org/pub/software/scm/git/git-htmldocs-2.10.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/git/git-htmldocs-2.10.1.tar.xz
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
    ./configure --prefix=/usr --with-gitconfig=/etc/gitconfig &&
    make "-j`nproc`" || make
    make DESTDIR=$PKG install
    tar -xf ../git-manpages-2.10.1.tar.xz \
    -C $PKG/usr/share/man --no-same-owner --no-overwrite-dir
    mkdir -vp $PKG/usr/share/doc/git-2.10.1 &&
    tar -xf ../git-htmldocs-2.10.1.tar.xz \
        -C $PKG/usr/share/doc/git-2.10.1 --no-same-owner --no-overwrite-dir &&
    find $PKG/usr/share/doc/git-2.10.1 -type d -exec chmod 755 {} \; &&
    find $PKG/usr/share/doc/git-2.10.1 -type f -exec chmod 644 {} \;
}

function package() {
    strip -s $PKG/usr/bin/git{,-receive-pack,-shell,-upload-archive,-upload-pack}
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
