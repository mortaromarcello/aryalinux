#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:guile:2.0.11

#REQ:gc
#REQ:libffi
#REQ:libunistring
#OPT:emacs
#OPT:gdb


cd $SOURCE_DIR

URL=http://ftp.gnu.org/pub/gnu/guile/guile-2.0.11.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/guile/guile-2.0.11.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/guile/guile-2.0.11.tar.xz || wget -nc http://ftp.gnu.org/pub/gnu/guile/guile-2.0.11.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/guile/guile-2.0.11.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/guile/guile-2.0.11.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/guile/guile-2.0.11.tar.xz || wget -nc ftp://ftp.gnu.org/pub/gnu/guile/guile-2.0.11.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/guile-2.0.11 &&
make      &&
make html &&
makeinfo --plaintext -o doc/r5rs/r5rs.txt doc/r5rs/r5rs.texi &&
makeinfo --plaintext -o doc/ref/guile.txt doc/ref/guile.texi



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install      &&
make install-html &&
mv /usr/lib/libguile-*-gdb.scm /usr/share/gdb/auto-load/usr/lib &&
mv /usr/share/doc/guile-2.0.11/{guile.html,ref} &&
mv /usr/share/doc/guile-2.0.11/r5rs{.html,}     &&
find examples -name "Makefile*" -delete         &&
cp -vR examples   /usr/share/doc/guile-2.0.11   &&
for DIRNAME in r5rs ref; do
  install -v -m644  doc/${DIRNAME}/*.txt \
                    /usr/share/doc/guile-2.0.11/${DIRNAME}
done &&
unset DIRNAME

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "guile=>`date`" | sudo tee -a $INSTALLED_LIST

