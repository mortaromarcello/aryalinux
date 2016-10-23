#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The lm_sensors package providesbr3ak user-space support for the hardware monitoring drivers in the Linuxbr3ak kernel. This is useful for monitoring the temperature of the CPUbr3ak and adjusting the performance of some hardware (such as coolingbr3ak fans).br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:general_which


#VER:lm_sensors:3.4.0


NAME="lm_sensors"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://pkgs.fedoraproject.org/repo/pkgs/lm_sensors/lm_sensors-3.4.0.tar.bz2/c03675ae9d43d60322110c679416901a/lm_sensors-3.4.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lmsensors/lm_sensors-3.4.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lmsensors/lm_sensors-3.4.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lmsensors/lm_sensors-3.4.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lmsensors/lm_sensors-3.4.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lmsensors/lm_sensors-3.4.0.tar.bz2


URL=http://pkgs.fedoraproject.org/repo/pkgs/lm_sensors/lm_sensors-3.4.0.tar.bz2/c03675ae9d43d60322110c679416901a/lm_sensors-3.4.0.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

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

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST