#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:Imaging:1.1.7
#VER:asymptote-.src:2.36

#REQ:freeglut
#REQ:gs
#REQ:texlive
#REC:gc
#OPT:gsl
#OPT:python2
#OPT:tk


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/sourceforge/asymptote/asymptote-2.36.src.tgz

wget -nc http://effbot.org/downloads/Imaging-1.1.7.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/downloads/Imaging/Imaging-1.1.7-freetype_fix-1.patch
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/asymptote/asymptote-2.36.src.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/asymptote/asymptote-2.36.src.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/asymptote/asymptote-2.36.src.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/asymptote/asymptote-2.36.src.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/asymptote/asymptote-2.36.src.tgz || wget -nc http://downloads.sourceforge.net/sourceforge/asymptote/asymptote-2.36.src.tgz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/') &&
./configure --prefix=/opt/texlive/2015 \
 --bindir=/opt/texlive/2015/bin/$TEXARCH \
 --datarootdir=/opt/texlive/2015/texmf-dist \
 --infodir=/opt/texlive/2015/texmf-dist/doc/info \
 --libdir=/opt/texlive/2015/texmf-dist \
 --mandir=/opt/texlive/2015/texmf-dist/doc/man \
 --enable-gc=system \
 --with-latex=/opt/texlive/2015/texmf-dist/tex/latex \
 --with-context=/opt/texlive/2015/texmf-dist/tex/context/third &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "asymptote=>`date`" | sudo tee -a $INSTALLED_LIST

