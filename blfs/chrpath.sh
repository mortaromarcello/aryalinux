#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:chrpath:0.16



cd $SOURCE_DIR

URL=https://alioth.debian.org/frs/download.php/latestfile/813/chrpath-0.16.tar.gz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/chrpath/chrpath-0.16.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/chrpath/chrpath-0.16.tar.gz || wget -nc https://alioth.debian.org/frs/download.php/latestfile/813/chrpath-0.16.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/chrpath/chrpath-0.16.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/chrpath/chrpath-0.16.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/chrpath/chrpath-0.16.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/chrpath-0.16 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "chrpath=>`date`" | sudo tee -a $INSTALLED_LIST

