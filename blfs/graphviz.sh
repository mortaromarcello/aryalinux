#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:graphviz:2.38.0

#REC:freetype2
#REC:fontconfig
#REC:freeglut
#REC:gdk-pixbuf
#REC:libjpeg
#REC:libpng
#REC:librsvg
#REC:pango
#REC:x7lib
#OPT:libglade
#OPT:gs
#OPT:gtk2
#OPT:qt5
#OPT:swig
#OPT:guile
#OPT:openjdk
#OPT:lua
#OPT:php
#OPT:python2
#OPT:ruby
#OPT:tcl
#OPT:tk


cd $SOURCE_DIR

URL=http://pkgs.fedoraproject.org/repo/pkgs/graphviz/graphviz-2.38.0.tar.gz/5b6a829b2ac94efcd5fa3c223ed6d3ae/graphviz-2.38.0.tar.gz

wget -nc http://www.linuxfromscratch.org/patches/downloads/graphviz/graphviz-2.38.0-consolidated_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/graphviz-2.38.0-consolidated_fixes-1.patch
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/graphviz/graphviz-2.38.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/graphviz/graphviz-2.38.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/graphviz/graphviz-2.38.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/graphviz/graphviz-2.38.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/graphviz/graphviz-2.38.0.tar.gz || wget -nc http://pkgs.fedoraproject.org/repo/pkgs/graphviz/graphviz-2.38.0.tar.gz/5b6a829b2ac94efcd5fa3c223ed6d3ae/graphviz-2.38.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../graphviz-2.38.0-consolidated_fixes-1.patch &&
autoreconf                               &&
./configure --prefix=/usr --disable-php  &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -v -s /usr/share/graphviz/doc \
         /usr/share/doc/graphviz-2.38.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "graphviz=>`date`" | sudo tee -a $INSTALLED_LIST

