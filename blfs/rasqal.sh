#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:rasqal:0.9.33

#REQ:raptor
#OPT:pcre
#OPT:libgcrypt


cd $SOURCE_DIR

URL=http://download.librdf.org/source/rasqal-0.9.33.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/rasqal/rasqal-0.9.33.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/rasqal/rasqal-0.9.33.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/rasqal/rasqal-0.9.33.tar.gz || wget -nc http://download.librdf.org/source/rasqal-0.9.33.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/rasqal/rasqal-0.9.33.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/rasqal/rasqal-0.9.33.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "rasqal=>`date`" | sudo tee -a $INSTALLED_LIST

