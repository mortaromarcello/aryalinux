#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak ePDFView is a free standalonebr3ak lightweight PDF document viewer using Poppler and GTK+ libraries. It is a good replacement forbr3ak Evince as it does not rely uponbr3ak GNOME libraries.br3ak
#SECTION:pst

whoami > /tmp/currentuser

#REQ:gtk2
#REQ:poppler
#REC:desktop-file-utils
#REC:hicolor-icon-theme
#OPT:cups


#VER:epdfview:0.1.8


NAME="epdfview"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/epdfview/epdfview-0.1.8.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/epdfview/epdfview-0.1.8.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/epdfview/epdfview-0.1.8.tar.bz2 || wget -nc http://anduin.linuxfromscratch.org/BLFS/epdfview/epdfview-0.1.8.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/epdfview/epdfview-0.1.8.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/epdfview/epdfview-0.1.8.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/downloads/epdfview/epdfview-0.1.8-fixes-2.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/epdfview-0.1.8-fixes-2.patch


URL=http://anduin.linuxfromscratch.org/BLFS/epdfview/epdfview-0.1.8.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../epdfview-0.1.8-fixes-2.patch &&
./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
for size in 24 32 48; do
  ln -svf ../../../../epdfview/pixmaps/icon_epdfview-$size.png \
          /usr/share/icons/hicolor/${size}x${size}/apps
done &&
unset size &&
update-desktop-database &&
gtk-update-icon-cache -t -f --include-image-data /usr/share/icons/hicolor

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
