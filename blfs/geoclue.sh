#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak GeoClue is a modularbr3ak geoinformation service built on top of the D-Bus messaging system. The goal of thebr3ak GeoClue project is to makebr3ak creating location-aware applications as simple as possible.br3ak"
SECTION="basicnet"
VERSION=0.12.0
NAME="geoclue"

#REQ:dbus-glib
#REQ:GConf
#REQ:libxslt
#REC:libsoup
#REC:networkmanager
#OPT:gtk2


cd $SOURCE_DIR

URL=https://launchpad.net/geoclue/trunk/0.12/+download/geoclue-0.12.0.tar.gz

if [ ! -z $URL ]
then
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/geoclue/geoclue-0.12.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/geoclue/geoclue-0.12.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/geoclue/geoclue-0.12.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/geoclue/geoclue-0.12.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/geoclue/geoclue-0.12.0.tar.gz || wget -nc https://launchpad.net/geoclue/trunk/0.12/+download/geoclue-0.12.0.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/downloads/geoclue/geoclue-0.12.0-gpsd_fix-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/geoclue-0.12.0-gpsd_fix-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

patch -Np1 -i ../geoclue-0.12.0-gpsd_fix-1.patch &&
sed -i "s@ -Werror@@" configure &&
sed -i "s@libnm_glib@libnm-glib@g" configure &&
sed -i "s@geoclue/libgeoclue.la@& -lgthread-2.0@g" \
       providers/skyhook/Makefile.in &&
./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
