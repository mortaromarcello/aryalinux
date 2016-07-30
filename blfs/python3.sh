#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:python-docs-html:3.5.2
#VER:Python:3.5.2

#REC:libffi
#OPT:bluez
#OPT:gdb
#OPT:valgrind
#OPT:db
#OPT:openssl
#OPT:sqlite
#OPT:tk


cd $SOURCE_DIR

URL=https://www.python.org/ftp/python/3.5.2/Python-3.5.2.tar.xz

wget -nc https://www.python.org/ftp/python/3.5.2/Python-3.5.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/Python/Python-3.5.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/Python/Python-3.5.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/Python/Python-3.5.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/Python/Python-3.5.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/Python/Python-3.5.2.tar.xz
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/Python/python-3.5.2-docs-html.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/Python/python-3.5.2-docs-html.tar.bz2 || wget -nc https://docs.python.org/3.5/archives/python-3.5.2-docs-html.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/Python/python-3.5.2-docs-html.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/Python/python-3.5.2-docs-html.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/Python/python-3.5.2-docs-html.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

CXX="/usr/bin/g++"              \
./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --without-ensurepip &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chmod -v 755 /usr/lib/libpython3.5m.so &&
chmod -v 755 /usr/lib/libpython3.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755 /usr/share/doc/python-3.5.2/html &&
tar --strip-components=1 \
    --no-same-owner \
    --no-same-permissions \
    -C /usr/share/doc/python-3.5.2/html \
    -xvf ../python-3.5.2-docs-html.tar.bz2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -svfn python-3.5.2 /usr/share/doc/python-3

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export PYTHONDOCS=/usr/share/doc/python-3/html

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "python3=>`date`" | sudo tee -a $INSTALLED_LIST

