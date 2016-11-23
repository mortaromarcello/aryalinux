#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Asymptote is a powerfulbr3ak descriptive vector graphics language that provides a naturalbr3ak coordinate-based framework for technical drawing. Labels andbr3ak equations can be typeset with LaTeX.br3ak"
SECTION="pst"
VERSION=2.38
NAME="asymptote"

#REQ:freeglut
#REQ:gs
#REQ:texlive
#REC:gc
#OPT:gsl
#OPT:python2
#OPT:tk


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/sourceforge/asymptote/asymptote-2.38.src.tgz

if [ ! -z $URL ]
then
wget -nc http://downloads.sourceforge.net/sourceforge/asymptote/asymptote-2.38.src.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/asymptote/asymptote-2.38.src.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/asymptote/asymptote-2.38.src.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/asymptote/asymptote-2.38.src.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/asymptote/asymptote-2.38.src.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/asymptote/asymptote-2.38.src.tgz
wget -nc http://effbot.org/downloads/Imaging-1.1.7.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/downloads/Imaging/Imaging-1.1.7-freetype_fix-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

export TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/') &&
./configure --prefix=/opt/texlive/2016 \
 --bindir=/opt/texlive/2016/bin/$TEXARCH \
 --datarootdir=/opt/texlive/2016/texmf-dist \
 --infodir=/opt/texlive/2016/texmf-dist/doc/info \
 --libdir=/opt/texlive/2016/texmf-dist \
 --mandir=/opt/texlive/2016/texmf-dist/doc/man \
 --enable-gc=system \
 --with-latex=/opt/texlive/2016/texmf-dist/tex/latex \
 --with-context=/opt/texlive/2016/texmf-dist/tex/context/third &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
