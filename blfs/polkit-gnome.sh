#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:polkit-gnome:0.105

#REQ:gtk3
#REQ:polkit


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/polkit-gnome/0.105/polkit-gnome-0.105.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/polkit-gnome/polkit-gnome-0.105.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/polkit-gnome/0.105/polkit-gnome-0.105.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/polkit-gnome/0.105/polkit-gnome-0.105.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/polkit-gnome/polkit-gnome-0.105.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/polkit-gnome/polkit-gnome-0.105.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/polkit-gnome/polkit-gnome-0.105.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/polkit-gnome/polkit-gnome-0.105.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -p /etc/xdg/autostart &&
cat > /etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop << "EOF"
[Desktop Entry]
Name=PolicyKit Authentication Agent
Comment=PolicyKit Authentication Agent
Exec=/usr/libexec/polkit-gnome-authentication-agent-1
Terminal=false
Type=Application
Categories= NoDisplay=true
OnlyShowIn=GNOME;XFCE;Unity;
AutostartCondition=GNOME3 unless-session gnome
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "polkit-gnome=>`date`" | sudo tee -a $INSTALLED_LIST

