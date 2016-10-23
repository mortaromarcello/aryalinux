#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libchamplain is a Clutterbr3ak based widget used to display rich, eye-candy and interactive maps.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:clutter
#REQ:gtk3
#REQ:libsoup
#REC:clutter-gtk
#REC:gobject-introspection
#REC:vala
#OPT:gtk-doc


#VER:libchamplain:0.12.14


NAME="libchamplain"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libchamplain/libchamplain-0.12.14.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libchamplain/0.12/libchamplain-0.12.14.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/libchamplain/0.12/libchamplain-0.12.14.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libchamplain/libchamplain-0.12.14.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libchamplain/libchamplain-0.12.14.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libchamplain/libchamplain-0.12.14.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libchamplain/libchamplain-0.12.14.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/libchamplain/0.12/libchamplain-0.12.14.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr    \
            --enable-vala    \
            --disable-static &&
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
