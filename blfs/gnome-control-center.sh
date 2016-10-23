#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GNOME Control Center packagebr3ak contains the GNOME settingsbr3ak manager.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:accountsservice
#REQ:clutter-gtk
#REQ:colord-gtk
#REQ:gnome-online-accounts
#REQ:gnome-settings-daemon
#REQ:grilo
#REQ:libgtop
#REQ:libpwquality
#REQ:mitkrb
#REQ:shared-mime-info
#REC:cheese
#REC:cups
#REC:samba
#REC:gnome-bluetooth
#REC:ibus
#REC:ModemManager
#REC:network-manager-applet
#OPT:cups-pk-helper
#OPT:gnome-color-manager
#OPT:sound-theme-freedesktop
#OPT:vino


#VER:gnome-control-center:3.22.0


NAME="gnome-control-center"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-control-center/gnome-control-center-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-control-center/3.22/gnome-control-center-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-control-center/gnome-control-center-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-control-center/gnome-control-center-3.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-control-center/3.22/gnome-control-center-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-control-center/gnome-control-center-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-control-center/gnome-control-center-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gnome-control-center/3.22/gnome-control-center-3.22.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../gnome-control-center-3.16.3-tzdata_fix-1.patch

./configure --prefix=/usr &&
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
