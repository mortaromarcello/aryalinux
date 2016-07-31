#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gimp:2.8.18
#VER:gimp-help:2.8.2

#REQ:gegl
#REQ:gtk2
#REC:python-modules#pygtk
#REC:libmypaint
#REQ:exiv2
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

wget -nc http://download.gimp.org/pub/gimp/v2.8/gimp-2.8.18.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gimp/gimp-2.8.18.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gimp/gimp-2.8.18.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gimp/gimp-2.8.18.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gimp/gimp-2.8.18.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gimp/gimp-2.8.18.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gimp/gimp-help-2.8.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gimp/gimp-help-2.8.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gimp/gimp-help-2.8.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gimp/gimp-help-2.8.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gimp/gimp-help-2.8.2.tar.bz2 || wget -nc http://download.gimp.org/pub/gimp/help/gimp-help-2.8.2.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i '/gegl/s/2/3/' configure.ac &&
sed -i '70,75 d' app/core/gimpparamspecs-duplicate.c &&
# autoreconf -fiv

GEGL_CFLAGS="`pkg-config --cflags geg-l0.3`"
GEGL_LIBS="`pkg-config --libs geg-l0.3`"
sed -i "/seems to be moved/s/^/#/" ltmain.sh &&
./configure --prefix=/usr \
            --sysconfdir=/etc \
            --without-gvfs &&
make "-j`nproc`"



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
ALL_LINGUAS="" ./configure --prefix=/usr &&
make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chown -R root:root /usr/share/gimp/2.0/help

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gimp=>`date`" | sudo tee -a $INSTALLED_LIST

