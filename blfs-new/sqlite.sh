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
DESCRIPTION=" The SQLite package is a software library that implements a self-contained, serverless, zero-configuration, transactional SQL database engine."
SECTION="server"
VERSION=3140100
NAME="sqlite"
PKGNAME=$NAME
REVISION=1

#OPT:unzip

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
    URL=http://sqlite.org/2016/sqlite-autoconf-3140100.tar.gz
    if [ ! -z $URL ]; then
        wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sqlite/sqlite-autoconf-3140100.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sqlite/sqlite-autoconf-3140100.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sqlite/sqlite-autoconf-3140100.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sqlite/sqlite-autoconf-3140100.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sqlite/sqlite-autoconf-3140100.tar.gz || wget -nc http://sqlite.org/2016/sqlite-autoconf-3140100.tar.gz
        wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sqlite/sqlite-doc-3140100.zip || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sqlite/sqlite-doc-3140100.zip || wget -nc http://sqlite.org/2016/sqlite-doc-3140100.zip || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sqlite/sqlite-doc-3140100.zip || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sqlite/sqlite-doc-3140100.zip || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sqlite/sqlite-doc-3140100.zip
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
    unzip -q ../sqlite-doc-3140100.zip
    ./configure --prefix=/usr --disable-static        \
                CFLAGS="-g -O2 -DSQLITE_ENABLE_FTS3=1 \
                -DSQLITE_ENABLE_COLUMN_METADATA=1     \
                -DSQLITE_ENABLE_UNLOCK_NOTIFY=1       \
                -DSQLITE_SECURE_DELETE=1              \
                -DSQLITE_ENABLE_DBSTAT_VTAB=1" &&
    make "-j`nproc`" || make
    make DESTDIR=$PKG install
    install -v -m755 -d $PKG/usr/share/doc/sqlite-3.15.0 &&
cp -v -R sqlite-doc-3140100/* $PKG/usr/share/doc/sqlite-3.14.1
}

function package() {
    strip -s $PKG/usr/bin/*
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
