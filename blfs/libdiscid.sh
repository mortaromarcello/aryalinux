#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libdiscid:0.6.1

#OPT:doxygen


cd $SOURCE_DIR

URL=http://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/libdiscid-0.6.1.tar.gz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdiscid/libdiscid-0.6.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libdiscid/libdiscid-0.6.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libdiscid/libdiscid-0.6.1.tar.gz || wget -nc ftp://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/libdiscid-0.6.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libdiscid/libdiscid-0.6.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdiscid/libdiscid-0.6.1.tar.gz || wget -nc http://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/libdiscid-0.6.1.tar.gz

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
echo "libdiscid=>`date`" | sudo tee -a $INSTALLED_LIST

