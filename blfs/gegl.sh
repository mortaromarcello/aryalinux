#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gegl:0.2.0

#REQ:babl
#REQ:glib2
#OPT:cairo
#OPT:enscript
#OPT:exiv2
#OPT:ffmpeg
#OPT:gdk-pixbuf
#OPT:graphviz
#OPT:libjpeg
#OPT:libpng
#OPT:librsvg
#OPT:lua
#OPT:pango
#OPT:python2
#OPT:ruby
#OPT:sdl
#OPT:gobject-introspection
#OPT:vala
#OPT:w3m


cd $SOURCE_DIR

URL=http://download.gimp.org/pub/gegl/0.2/gegl-0.2.0.tar.bz2

wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/gegl-0.2.0-ffmpeg2-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/gegl/gegl-0.2.0-ffmpeg2-1.patch
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gegl/gegl-0.2.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gegl/gegl-0.2.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gegl/gegl-0.2.0.tar.bz2 || wget -nc http://download.gimp.org/pub/gegl/0.2/gegl-0.2.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gegl/gegl-0.2.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gegl/gegl-0.2.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../gegl-0.2.0-ffmpeg2-1.patch &&
./configure --prefix=/usr &&
LC_ALL=en_US make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m644 docs/*.{css,html} /usr/share/gtk-doc/html/gegl &&
install -d -v -m755 /usr/share/gtk-doc/html/gegl/images &&
install -v -m644 docs/images/* /usr/share/gtk-doc/html/gegl/images

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gegl=>`date`" | sudo tee -a $INSTALLED_LIST

