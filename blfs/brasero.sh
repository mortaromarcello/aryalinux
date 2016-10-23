#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Brasero is an application used tobr3ak burn CD/DVD on the GNOME Desktop.br3ak It is designed to be as simple as possible and has some uniquebr3ak features that enable users to create their discs easily andbr3ak quickly.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:gst10-plugins-base
#REQ:itstool
#REQ:libcanberra
#REQ:libnotify
#REC:gobject-introspection
#REC:libburn
#REC:libisofs
#REC:nautilus
#REC:totem-pl-parser
#REC:dvd-rw-tools
#REC:gvfs
#OPT:gtk-doc
#OPT:cdrdao
#OPT:libdvdcss


#VER:brasero:3.12.1


NAME="brasero"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/brasero/brasero-3.12.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/brasero/brasero-3.12.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/brasero/brasero-3.12.1.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/brasero/3.12/brasero-3.12.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/brasero/brasero-3.12.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/brasero/brasero-3.12.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/brasero/3.12/brasero-3.12.1.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/brasero/3.12/brasero-3.12.1.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr                \
            --enable-compile-warnings=no \
            --enable-cxx-warnings=no     &&
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
