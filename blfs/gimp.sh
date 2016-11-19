#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Gimp package contains the GNUbr3ak Image Manipulation Program which is useful for photo retouching,br3ak image composition and image authoring.br3ak"
SECTION="xsoft"
VERSION=2.8.18
NAME="gimp"

#REQ:gegl
#REQ:gtk2
#REC:python-modules#pygtk
#OPT:aalib
#OPT:alsa-lib
#OPT:curl
#OPT:dbus-glib
#OPT:gs
#OPT:gvfs
#OPT:iso-codes
#OPT:jasper
#OPT:lcms
#OPT:lcms2
#OPT:libexif
#OPT:libgudev
#OPT:libmng
#OPT:librsvg
#OPT:poppler
#OPT:gtk-doc
#OPT:webkitgtk2


cd $SOURCE_DIR

URL=http://download.gimp.org/pub/gimp/v2.8/gimp-2.8.18.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://download.gimp.org/pub/gimp/v2.8/gimp-2.8.18.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gimp/gimp-2.8.18.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gimp/gimp-2.8.18.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gimp/gimp-2.8.18.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gimp/gimp-2.8.18.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gimp/gimp-2.8.18.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gimp/gimp-help-2.8.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gimp/gimp-help-2.8.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gimp/gimp-help-2.8.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gimp/gimp-help-2.8.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gimp/gimp-help-2.8.2.tar.bz2 || wget -nc http://download.gimp.org/pub/gimp/help/gimp-help-2.8.2.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

sed -i '/gegl/s/2/3/' configure &&
sed -i '70,75 d' app/core/gimpparamspecs-duplicate.c


sed -i "/seems to be moved/s/^/#/" ltmain.sh &&
./configure --prefix=/usr \
            --sysconfdir=/etc \
            --without-gvfs &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gtk-update-icon-cache &&
update-desktop-database

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


HELPTARBALL=`ls ../gimp-help*`
HELPDIR=`tar tf $HELPTARBALL | cut -d/ -f1 | uniq`
tar xf $HELPTARBALL
cd $HELPDIR
ALL_LINGUAS=`read -p "Enter the language for which gimp help is to be built from these ca da de el en en_GB es fr it ja ko nl nn pt_BR ru sl sv zh_CN : " LANGUAGE; echo $LANGUAGE`"" \
./configure --prefix=/usr &&


make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chown -R root:root /usr/share/gimp/2.0/help

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
