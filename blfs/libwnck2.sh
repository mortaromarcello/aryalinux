#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libwnck package contains abr3ak Window Navigator Construction Kit.br3ak
#SECTION:xfce

whoami > /tmp/currentuser

#REQ:gtk2
#REC:startup-notification
#OPT:gobject-introspection
#OPT:gtk-doc


#VER:libwnck:2.30.7


NAME="libwnck2"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libwnck/2.30/libwnck-2.30.7.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libwnck/libwnck-2.30.7.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libwnck/libwnck-2.30.7.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/libwnck/2.30/libwnck-2.30.7.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libwnck/libwnck-2.30.7.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libwnck/libwnck-2.30.7.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libwnck/libwnck-2.30.7.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/libwnck/2.30/libwnck-2.30.7.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --disable-static \
            --program-suffix=-1 &&
make GETTEXT_PACKAGE=libwnck-1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make GETTEXT_PACKAGE=libwnck-1 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
