#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:lm_sensors:3.4.0

#REQ:general_which


cd $SOURCE_DIR

URL=http://pkgs.fedoraproject.org/repo/pkgs/lm_sensors/lm_sensors-3.4.0.tar.bz2/c03675ae9d43d60322110c679416901a/lm_sensors-3.4.0.tar.bz2

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lmsensors/lm_sensors-3.4.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lmsensors/lm_sensors-3.4.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lmsensors/lm_sensors-3.4.0.tar.bz2 || wget -nc http://pkgs.fedoraproject.org/repo/pkgs/lm_sensors/lm_sensors-3.4.0.tar.bz2/c03675ae9d43d60322110c679416901a/lm_sensors-3.4.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lmsensors/lm_sensors-3.4.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lmsensors/lm_sensors-3.4.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

make PREFIX=/usr        \
     BUILD_STATIC_LIB=0 \
     MANDIR=/usr/share/man



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make PREFIX=/usr        \
     BUILD_STATIC_LIB=0 \
     MANDIR=/usr/share/man install &&
install -v -m755 -d /usr/share/doc/lm_sensors-3.4.0 &&
cp -rv              README INSTALL doc/* \
                    /usr/share/doc/lm_sensors-3.4.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "lm_sensors=>`date`" | sudo tee -a $INSTALLED_LIST

