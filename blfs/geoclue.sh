#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak GeoClue is a modularbr3ak geoinformation service built on top of the D-Bus messaging system. The goal of thebr3ak GeoClue project is to makebr3ak creating location-aware applications as simple as possible.br3ak
#SECTION:basicnet

whoami > /tmp/currentuser

#REQ:dbus-glib
#REQ:GConf
#REQ:libxslt
#REC:libsoup
#REC:networkmanager
#OPT:gtk2


#VER:geoclue:0.12.0


NAME="geoclue"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/geoclue/geoclue-0.12.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/geoclue/geoclue-0.12.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/geoclue/geoclue-0.12.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/geoclue/geoclue-0.12.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/geoclue/geoclue-0.12.0.tar.gz || wget -nc https://launchpad.net/geoclue/trunk/0.12/+download/geoclue-0.12.0.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/downloads/geoclue/geoclue-0.12.0-gpsd_fix-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/geoclue-0.12.0-gpsd_fix-1.patch


URL=https://launchpad.net/geoclue/trunk/0.12/+download/geoclue-0.12.0.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../geoclue-0.12.0-gpsd_fix-1.patch &&
sed -i "s@ -Werror@@" configure &&
sed -i "s@libnm_glib@libnm-glib@g" configure &&
sed -i "s@geoclue/libgeoclue.la@& -lgthread-2.0@g" \
       providers/skyhook/Makefile.in &&
./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
