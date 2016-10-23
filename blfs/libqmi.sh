#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libqmi package contains abr3ak GLib-based library for talking to WWAN modems and devices whichbr3ak speak the Qualcomm MSM Interface (QMI) protocol.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:glib2
#REC:libmbim
#OPT:gtk-doc


#VER:libqmi:1.16.0


NAME="libqmi"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://www.freedesktop.org/software/libqmi/libqmi-1.16.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libqmi/libqmi-1.16.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libqmi/libqmi-1.16.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libqmi/libqmi-1.16.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libqmi/libqmi-1.16.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libqmi/libqmi-1.16.0.tar.xz


URL=http://www.freedesktop.org/software/libqmi/libqmi-1.16.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
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
