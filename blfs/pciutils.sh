#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The PCI Utils package contains abr3ak set of programs for listing PCI devices, inspecting their statusbr3ak and setting their configuration registers.br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:pciutils:3.5.2


NAME="pciutils"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.kernel.org/pub/software/utils/pciutils/pciutils-3.5.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pciutils/pciutils-3.5.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pciutils/pciutils-3.5.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pciutils/pciutils-3.5.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pciutils/pciutils-3.5.2.tar.xz || wget -nc https://ftp.kernel.org/pub/software/utils/pciutils/pciutils-3.5.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pciutils/pciutils-3.5.2.tar.xz


URL=https://ftp.kernel.org/pub/software/utils/pciutils/pciutils-3.5.2.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

make PREFIX=/usr                \
     SHAREDIR=/usr/share/hwdata \
     SHARED=yes



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make PREFIX=/usr                \
     SHAREDIR=/usr/share/hwdata \
     SHARED=yes                 \
     install install-lib        &&
chmod -v 755 /usr/lib/libpci.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
