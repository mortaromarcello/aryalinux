#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Graphviz package containsbr3ak graph visualization software. Graph visualization is a way ofbr3ak representing structural information as diagrams of abstract graphsbr3ak and networks. Graphviz has severalbr3ak main graph layout programs. It also has web and interactivebr3ak graphical interfaces, auxiliary tools, libraries, and languagebr3ak bindings.br3ak
#SECTION:general

whoami > /tmp/currentuser

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


#VER:graphviz:2.38.0


NAME="graphviz"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/graphviz/graphviz-2.38.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/graphviz/graphviz-2.38.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/graphviz/graphviz-2.38.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/graphviz/graphviz-2.38.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/graphviz/graphviz-2.38.0.tar.gz || wget -nc http://pkgs.fedoraproject.org/repo/pkgs/graphviz/graphviz-2.38.0.tar.gz/5b6a829b2ac94efcd5fa3c223ed6d3ae/graphviz-2.38.0.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/downloads/graphviz/graphviz-2.38.0-consolidated_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/graphviz-2.38.0-consolidated_fixes-1.patch


URL=http://pkgs.fedoraproject.org/repo/pkgs/graphviz/graphviz-2.38.0.tar.gz/5b6a829b2ac94efcd5fa3c223ed6d3ae/graphviz-2.38.0.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
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

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
