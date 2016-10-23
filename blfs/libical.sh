#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libical package contains anbr3ak implementation of the iCalendar protocols and data formats.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:cmake
#OPT:db
#OPT:doxygen
#OPT:gobject-introspection
#OPT:icu


#VER:libical:2.0.0


NAME="libical"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libical/libical-2.0.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libical/libical-2.0.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libical/libical-2.0.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libical/libical-2.0.0.tar.gz || wget -nc https://github.com/libical/libical/releases/download/v2.0.0/libical-2.0.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libical/libical-2.0.0.tar.gz


URL=https://github.com/libical/libical/releases/download/v2.0.0/libical-2.0.0.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir build &&
cd build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DSHARED_ONLY=yes           \
      .. &&
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
