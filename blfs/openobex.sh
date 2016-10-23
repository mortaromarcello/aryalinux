#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The OpenOBEX package contains abr3ak library that implements Object Exchange Protocol used for binarybr3ak file transfers between devices.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:cmake
#REQ:libusb
#REC:bluez
#OPT:doxygen
#OPT:libxslt
#OPT:openjdk
#OPT:xmlto


#VER:openobex-Source:1.7.2


NAME="openobex"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://downloads.sourceforge.net/openobex/openobex-1.7.2-Source.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openobex/openobex-1.7.2-Source.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openobex/openobex-1.7.2-Source.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openobex/openobex-1.7.2-Source.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openobex/openobex-1.7.2-Source.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openobex/openobex-1.7.2-Source.tar.gz


URL=http://downloads.sourceforge.net/openobex/openobex-1.7.2-Source.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 90 plugdev

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr      \
      -DCMAKE_INSTALL_LIBDIR=/usr/lib  \
      -DCMAKE_BUILD_TYPE=Release       \
      -Wno-dev                         \
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
