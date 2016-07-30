#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gavl:1.4.0



cd $SOURCE_DIR

URL=http://sourceforge.net/projects/gmerlin/files/gavl/1.4.0/gavl-1.4.0.tar.gz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gavl/gavl-1.4.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gavl/gavl-1.4.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gavl/gavl-1.4.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gavl/gavl-1.4.0.tar.gz || wget -nc http://sourceforge.net/projects/gmerlin/files/gavl/1.4.0/gavl-1.4.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gavl/gavl-1.4.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --disable-doxygen                \
            --docdir=/usr/share/doc/gavl-1.4.0 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gavl=>`date`" | sudo tee -a $INSTALLED_LIST

