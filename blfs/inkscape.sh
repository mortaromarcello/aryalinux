#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Inkscape is a what you see is whatbr3ak you get Scalable Vector Graphics editor. It is useful for creating,br3ak viewing and changing SVG images.br3ak
#SECTION:xsoft

#REQ:boost
#REQ:gc
#REQ:gsl
#REQ:gtkmm2
#REQ:gtkmm3
#REQ:libxslt
#REQ:popt
#REC:lcms2
#REC:lcms
#OPT:aspell
#OPT:dbus
#OPT:doxygen
#OPT:imagemagick
#OPT:poppler


#VER:inkscape:0.91


NAME="inkscape"

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/inkscape/inkscape-0.91.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/inkscape/inkscape-0.91.tar.bz2 || wget -nc https://launchpad.net/inkscape/0.91.x/0.91/+download/inkscape-0.91.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/inkscape/inkscape-0.91.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/inkscape/inkscape-0.91.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/inkscape/inkscape-0.91.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/inkscape-0.91-testfiles-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/inkscape/inkscape-0.91-testfiles-1.patch


URL=https://launchpad.net/inkscape/0.91.x/0.91/+download/inkscape-0.91.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../inkscape-0.91-testfiles-1.patch &&

sed -e 's/ScopedPtr<char>/make_unique_ptr_gfree/' \
    -i src/ui/clipboard.cpp  &&

CXXFLAGS="-g -O2 -std=c++11" ./configure --prefix=/usr &&
make


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




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
