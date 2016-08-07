#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:pcre:8.39

#OPT:valgrind


cd $SOURCE_DIR

URL=ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.bz2

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pcre/pcre-8.39.tar.bz2 || wget -nc ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pcre/pcre-8.39.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pcre/pcre-8.39.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pcre/pcre-8.39.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pcre/pcre-8.39.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr                     \
            --docdir=/usr/share/doc/pcre-8.39 \
            --enable-unicode-properties       \
            --enable-pcre16                   \
            --enable-pcre32                   \
            --enable-pcregrep-libz            \
            --enable-pcregrep-libbz2          \
            --enable-pcretest-libreadline     \
            --disable-static                 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                     &&
mv -v /usr/lib/libpcre.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libpcre.so) /usr/lib/libpcre.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "pcre=>`date`" | sudo tee -a $INSTALLED_LIST

