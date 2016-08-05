#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:expect:5.45

#REQ:tcl
#OPT:tk


cd $SOURCE_DIR

URL=http://prdownloads.sourceforge.net/expect/expect5.45.tar.gz

wget -nc http://prdownloads.sourceforge.net/expect/expect5.45.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/expect/expect5.45.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/expect/expect5.45.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/expect/expect5.45.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/expect/expect5.45.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/expect/expect5.45.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
ln -svf expect5.45/libexpect5.45.so /usr/lib

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "expect=>`date`" | sudo tee -a $INSTALLED_LIST

