#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Hdparm package contains abr3ak utility that is useful for controlling ATA/IDE controllers and hardbr3ak drives both to increase performance and sometimes to increasebr3ak stability.br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:hdparm:9.49


NAME="hdparm"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/hdparm/hdparm-9.49.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/hdparm/hdparm-9.49.tar.gz || wget -nc http://downloads.sourceforge.net/hdparm/hdparm-9.49.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/hdparm/hdparm-9.49.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/hdparm/hdparm-9.49.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/hdparm/hdparm-9.49.tar.gz


URL=http://downloads.sourceforge.net/hdparm/hdparm-9.49.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make binprefix=/usr install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
