#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libxml2 package containsbr3ak libraries and utilities used for parsing XML files.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REC:python2
#REC:python3
#OPT:valgrind


#VER:libxml2:2.9.4
#VER:xmlts:20130923


NAME="libxml2"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libxml/libxml2-2.9.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxml/libxml2-2.9.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxml/libxml2-2.9.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libxml/libxml2-2.9.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libxml/libxml2-2.9.4.tar.gz || wget -nc http://xmlsoft.org/sources/libxml2-2.9.4.tar.gz || wget -nc ftp://xmlsoft.org/libxml2/libxml2-2.9.4.tar.gz
wget -nc http://www.w3.org/XML/Test/xmlts20130923.tar.gz


URL=http://xmlsoft.org/sources/libxml2-2.9.4.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i "/seems to be moved/s/^/#/" ltmain.sh &&
./configure --prefix=/usr --disable-static --with-history &&
make "-j`nproc`" || make


tar xf ../xmlts20130923.tar.gz



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
