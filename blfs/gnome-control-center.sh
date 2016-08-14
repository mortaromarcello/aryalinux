#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gnome-control-center:3.20.1

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


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gnome-control-center/3.20/gnome-control-center-3.20.1.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-control-center/gnome-control-center-3.20.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-control-center/gnome-control-center-3.20.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-control-center/gnome-control-center-3.20.1.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-control-center/3.20/gnome-control-center-3.20.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-control-center/gnome-control-center-3.20.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-control-center/gnome-control-center-3.20.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-control-center/3.20/gnome-control-center-3.20.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
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
echo "gnome-control-center=>`date`" | sudo tee -a $INSTALLED_LIST

