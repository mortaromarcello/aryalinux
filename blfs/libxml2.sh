#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libxml2:2.9.3
#VER:xmlts:20130923

#REC:python2
#REC:python3
#OPT:valgrind


cd $SOURCE_DIR

URL=http://xmlsoft.org/sources/libxml2-2.9.3.tar.gz

wget -nc http://www.w3.org/XML/Test/xmlts20130923.tar.gz
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxml/libxml2-2.9.3.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxml/libxml2-2.9.3.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libxml/libxml2-2.9.3.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libxml/libxml2-2.9.3.tar.gz || wget -nc http://xmlsoft.org/sources/libxml2-2.9.3.tar.gz || wget -nc ftp://xmlsoft.org/libxml2/libxml2-2.9.3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libxml/libxml2-2.9.3.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static --with-history &&
make "-j`nproc`"


tar xf ../xmlts20130923.tar.gz



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libxml2=>`date`" | sudo tee -a $INSTALLED_LIST

