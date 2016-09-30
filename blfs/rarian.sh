#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:rarian:0.8.1

#REC:libxslt
#REC:docbook


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/rarian/0.8/rarian-0.8.1.tar.bz2

wget -nc ftp://ftp.gnome.org/pub/gnome/sources/rarian/0.8/rarian-0.8.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/rarian/rarian-0.8.1.tar.bz2 || wget -nc http://ftp.gnome.org/pub/gnome/sources/rarian/0.8/rarian-0.8.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/rarian/rarian-0.8.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/rarian/rarian-0.8.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/rarian/rarian-0.8.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/rarian/rarian-0.8.1.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --localstatedir=/var &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "rarian=>`date`" | sudo tee -a $INSTALLED_LIST

