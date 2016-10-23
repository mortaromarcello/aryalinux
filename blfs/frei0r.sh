#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Frei0r is a minimalistic pluginbr3ak API for video effects. Note that the 0 in the name is a zero, not abr3ak capital letter o.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser



#VER:frei0r-plugins:1.5.0


NAME="frei0r"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/frei0r/frei0r-plugins-1.5.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/frei0r/frei0r-plugins-1.5.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/frei0r/frei0r-plugins-1.5.0.tar.gz || wget -nc https://files.dyne.org/frei0r/releases/frei0r-plugins-1.5.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/frei0r/frei0r-plugins-1.5.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/frei0r/frei0r-plugins-1.5.0.tar.gz


URL=https://files.dyne.org/frei0r/releases/frei0r-plugins-1.5.0.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir -vp build &&
cd        build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr    \
      -DCMAKE_BUILD_TYPE=Release     \
      -DOpenCV_DIR=/usr/share/OpenCV \
      -Wno-dev ..                    &&
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