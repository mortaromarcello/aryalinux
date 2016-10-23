#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The smartmontools package containsbr3ak utility programs (smartctl, smartd) to control/monitor storagebr3ak systems using the Self-Monitoring, Analysis and Reportingbr3ak Technology System (S.M.A.R.T.) built into most modern ATA and SCSIbr3ak disks.br3ak
#SECTION:postlfs

whoami > /tmp/currentuser

#OPT:curl
#OPT:lynx
#OPT:wget


#VER:smartmontools:6.5


NAME="smartmontools"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/smartmontools/smartmontools-6.5.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/smartmontools/smartmontools-6.5.tar.gz || wget -nc http://sourceforge.net/projects/smartmontools/files/smartmontools/6.5/smartmontools-6.5.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/smartmontools/smartmontools-6.5.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/smartmontools/smartmontools-6.5.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/smartmontools/smartmontools-6.5.tar.gz


URL=http://sourceforge.net/projects/smartmontools/files/smartmontools/6.5/smartmontools-6.5.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr           \
            --sysconfdir=/etc       \
            --with-initscriptdir=no \
            --docdir=/usr/share/doc/smartmontools-6.5 &&
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