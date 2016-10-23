#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Xfburn is a GTK+ 2 GUI frontend for Libisoburn. This is useful for creating CDsbr3ak and DVDs from files on your computer or ISO images downloaded frombr3ak elsewhere.br3ak
#SECTION:xfce

whoami > /tmp/currentuser

#REQ:exo
#REQ:libxfce4util
#REQ:libisoburn
#REQ:gst10-plugins-base
#OPT:cdrdao


#VER:xfburn:0.5.4


NAME="xfburn"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xfburn/xfburn-0.5.4.tar.bz2 || wget -nc http://archive.xfce.org/src/apps/xfburn/0.5/xfburn-0.5.4.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfburn/xfburn-0.5.4.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xfburn/xfburn-0.5.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfburn/xfburn-0.5.4.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xfburn/xfburn-0.5.4.tar.bz2


URL=http://archive.xfce.org/src/apps/xfburn/0.5/xfburn-0.5.4.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
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