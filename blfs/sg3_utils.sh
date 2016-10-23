#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The sg3_utils package contains lowbr3ak level utilities for devices that use a SCSI command set. Apart frombr3ak SCSI parallel interface (SPI) devices, the SCSI command set is usedbr3ak by ATAPI devices (CD/DVDs and tapes), USB mass storage devices,br3ak Fibre Channel disks, IEEE 1394 storage devices (that use the "SBP"br3ak protocol), SAS, iSCSI and FCoE devices (amongst others).br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:sg3_utils:1.42


NAME="sg3_utils"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sg3_utils/sg3_utils-1.42.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sg3_utils/sg3_utils-1.42.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sg3_utils/sg3_utils-1.42.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sg3_utils/sg3_utils-1.42.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sg3_utils/sg3_utils-1.42.tar.xz || wget -nc http://sg.danny.cz/sg/p/sg3_utils-1.42.tar.xz


URL=http://sg.danny.cz/sg/p/sg3_utils-1.42.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
