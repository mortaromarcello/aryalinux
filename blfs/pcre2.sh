#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:pcre2:10.22

#OPT:valgrind


cd $SOURCE_DIR

URL=ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre2-10.22.tar.bz2

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pcre2/pcre2-10.22.tar.bz2 || wget -nc ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre2-10.22.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pcre2/pcre2-10.22.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pcre2/pcre2-10.22.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pcre2/pcre2-10.22.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pcre2/pcre2-10.22.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr                       \
            --docdir=/usr/share/doc/pcre2-10.22 \
            --enable-unicode                    \
            --enable-pcre2-16                   \
            --enable-pcre2-32                   \
            --enable-pcre2grep-libz             \
            --enable-pcre2grep-libbz2           \
            --enable-pcre2test-libreadline      \
            --disable-static                    &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "pcre2=>`date`" | sudo tee -a $INSTALLED_LIST

