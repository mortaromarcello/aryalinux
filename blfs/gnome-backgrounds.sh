#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GNOME Backgrounds packagebr3ak contains a collection of graphics files which can be used asbr3ak backgrounds in the GNOME Desktopbr3ak environment. Additionally, the package creates the proper frameworkbr3ak and directory structure so that you can add your own files to thebr3ak collection.br3ak
#SECTION:gnome

whoami > /tmp/currentuser



#VER:gnome-backgrounds:3.22.1


NAME="gnome-backgrounds"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-backgrounds/3.22/gnome-backgrounds-3.22.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-backgrounds/gnome-backgrounds-3.22.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-backgrounds/gnome-backgrounds-3.22.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-backgrounds/gnome-backgrounds-3.22.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-backgrounds/3.22/gnome-backgrounds-3.22.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-backgrounds/gnome-backgrounds-3.22.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-backgrounds/gnome-backgrounds-3.22.1.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gnome-backgrounds/3.22/gnome-backgrounds-3.22.1.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
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




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
