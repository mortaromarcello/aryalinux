#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Python 2 package contains thebr3ak Python development environment. Itbr3ak is useful for object-oriented programming, writing scripts,br3ak prototyping large programs or developing entire applications. Thisbr3ak version is for backward compatibility with other dependentbr3ak packages.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REC:libffi
#OPT:bluez
#OPT:valgrind
#OPT:openssl
#OPT:sqlite
#OPT:tk


#VER:python-docs-html:2.7.12
#VER:Python:2.7.12


NAME="python2"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/Python/Python-2.7.12.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/Python/Python-2.7.12.tar.xz || wget -nc https://www.python.org/ftp/python/2.7.12/Python-2.7.12.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/Python/Python-2.7.12.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/Python/Python-2.7.12.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/Python/Python-2.7.12.tar.xz
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/Python/python-2.7.12-docs-html.tar.bz2 || wget -nc https://docs.python.org/2.7/archives/python-2.7.12-docs-html.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/Python/python-2.7.12-docs-html.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/Python/python-2.7.12-docs-html.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/Python/python-2.7.12-docs-html.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/Python/python-2.7.12-docs-html.tar.bz2


URL=https://www.python.org/ftp/python/2.7.12/Python-2.7.12.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --enable-unicode=ucs4 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chmod -v 755 /usr/lib/libpython2.7.so.1.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755 /usr/share/doc/python-2.7.12 &&
tar --strip-components=1                     \
    --no-same-owner                          \
    --directory /usr/share/doc/python-2.7.12 \
    -xvf ../python-2.7.12-docs-html.tar.bz2 &&
find /usr/share/doc/python-2.7.12 -type d -exec chmod 0755 {} \; &&
find /usr/share/doc/python-2.7.12 -type f -exec chmod 0644 {} \;

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export PYTHONDOCS=/usr/share/doc/python-2.7.12

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
