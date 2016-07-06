#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:swig:3.0.8

#REQ:pcre
#OPT:boost


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/swig/swig-3.0.8.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/swig/swig-3.0.8.tar.gz || wget -nc http://downloads.sourceforge.net/swig/swig-3.0.8.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/swig/swig-3.0.8.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/swig/swig-3.0.8.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/swig/swig-3.0.8.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/swig/swig-3.0.8.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr                      \
            --without-clisp                    \
            --without-maximum-compile-warnings &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/swig-3.0.8 &&
cp -v -R Doc/* /usr/share/doc/swig-3.0.8

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "swig=>`date`" | sudo tee -a $INSTALLED_LIST

