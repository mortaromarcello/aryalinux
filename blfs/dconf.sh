#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The DConf package contains abr3ak low-level configuration system. Its main purpose is to provide abr3ak backend to GSettings on platforms that don't already havebr3ak configuration storage systems.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:dbus
#REQ:glib2
#REQ:gtk3
#REQ:libxml2
#REC:libxslt
#REC:vala
#OPT:gtk-doc


#VER:dconf:0.26.0
#VER:dconf-editor:3.22.0


NAME="dconf"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/dconf/dconf-0.26.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/dconf/0.26/dconf-0.26.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/dconf/dconf-0.26.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/dconf/dconf-0.26.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/dconf/dconf-0.26.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/dconf/dconf-0.26.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/dconf/0.26/dconf-0.26.0.tar.xz
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/dconf/dconf-editor-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/dconf/dconf-editor-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/dconf/dconf-editor-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/dconf-editor/3.22/dconf-editor-3.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/dconf-editor/3.22/dconf-editor-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/dconf/dconf-editor-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/dconf/dconf-editor-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/dconf/0.26/dconf-0.26.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


tar -xf ../dconf-editor-3.22.0.tar.xz &&
cd dconf-editor-3.22.0 &&
./configure --prefix=/usr --sysconfdir=/etc &&
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
