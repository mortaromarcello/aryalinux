#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak NPAPI-SDK is a bundle of Netscapebr3ak Plugin Application Programming Interface headers by Mozilla. Thisbr3ak package provides a clear way to install those headers and depend onbr3ak them.br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:npapi-sdk:0.27.2


NAME="npapi-sdk"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/npapi-sdk/npapi-sdk-0.27.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/npapi-sdk/npapi-sdk-0.27.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/npapi-sdk/npapi-sdk-0.27.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/npapi-sdk/npapi-sdk-0.27.2.tar.bz2 || wget -nc https://bitbucket.org/mgorny/npapi-sdk/downloads/npapi-sdk-0.27.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/npapi-sdk/npapi-sdk-0.27.2.tar.bz2


URL=https://bitbucket.org/mgorny/npapi-sdk/downloads/npapi-sdk-0.27.2.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
