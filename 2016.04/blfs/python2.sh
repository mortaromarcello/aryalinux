#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:python-docs-html:2.7.11
#VER:Python:2.7.11

#REC:libffi
#OPT:bluez
#OPT:valgrind
#OPT:openssl
#OPT:sqlite
#OPT:tk


cd $SOURCE_DIR

URL=https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/Python/python-2.7.11-docs-html.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/Python/python-2.7.11-docs-html.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/Python/python-2.7.11-docs-html.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/Python/python-2.7.11-docs-html.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/Python/python-2.7.11-docs-html.tar.bz2 || wget -nc https://docs.python.org/2.7/archives/python-2.7.11-docs-html.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/Python/Python-2.7.11.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/Python/Python-2.7.11.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/Python/Python-2.7.11.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/Python/Python-2.7.11.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/Python/Python-2.7.11.tar.xz || wget -nc https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

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
install -v -dm755 /usr/share/doc/python-2.7.11 &&
tar --strip-components=1                     \
    --no-same-owner                          \
    --directory /usr/share/doc/python-2.7.11 \
    -xvf ../python-2.7.11-docs-html.tar.bz2 &&
find /usr/share/doc/python-2.7.11 -type d -exec chmod 0755 {} \; &&
find /usr/share/doc/python-2.7.11 -type f -exec chmod 0644 {} \;

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export PYTHONDOCS=/usr/share/doc/python-2.7.11

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "python2=>`date`" | sudo tee -a $INSTALLED_LIST

