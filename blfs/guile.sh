#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The Guile package contains the GNUbr3ak Project's extension language library. Guile also contains a stand alone Scheme interpreter.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:gc
#REQ:libffi
#REQ:libunistring
#OPT:emacs
#OPT:gdb


#VER:guile:2.0.13


NAME="guile"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/guile/guile-2.0.13.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/guile/guile-2.0.13.tar.xz || wget -nc http://ftp.gnu.org/pub/gnu/guile/guile-2.0.13.tar.xz || wget -nc ftp://ftp.gnu.org/pub/gnu/guile/guile-2.0.13.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/guile/guile-2.0.13.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/guile/guile-2.0.13.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/guile/guile-2.0.13.tar.xz


URL=http://ftp.gnu.org/pub/gnu/guile/guile-2.0.13.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i "/seems to be moved/s/^/:#/" build-aux/ltmain.sh &&
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/guile-2.0.13 &&
make      &&
make html &&
makeinfo --plaintext -o doc/r5rs/r5rs.txt doc/r5rs/r5rs.texi &&
makeinfo --plaintext -o doc/ref/guile.txt doc/ref/guile.texi



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install      &&
make install-html &&
mv /usr/lib/libguile-*-gdb.scm /usr/share/gdb/auto-load/usr/lib &&
mv /usr/share/doc/guile-2.0.13/{guile.html,ref} &&
mv /usr/share/doc/guile-2.0.13/r5rs{.html,}     &&
find examples -name "Makefile*" -delete         &&
cp -vR examples   /usr/share/doc/guile-2.0.13   &&
for DIRNAME in r5rs ref; do
  install -v -m644  doc/${DIRNAME}/*.txt \
                    /usr/share/doc/guile-2.0.13/${DIRNAME}
done &&
unset DIRNAME

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
