#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The TeX Live package is abr3ak comprehensive TeX document production system. It includes TeX,br3ak LaTeX2e, ConTeXt, Metafont, MetaPost, BibTeX and many otherbr3ak programs; an extensive collection of macros, fonts andbr3ak documentation; and support for typesetting in many differentbr3ak scripts from around the world.br3ak
#SECTION:pst

whoami > /tmp/currentuser

#REC:gnupg
#REC:gs
#REC:x7lib
#REC:libxcb
#REC:epdfview
#REC:glu
#REC:freeglut
#REC:python2
#REC:ruby
#REC:xorg-server


#VER:readline:5.2
#VER:install-tl-unx:null


NAME="tl-installer"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
wget -nc ftp://ftp.gnu.org/gnu/readline/readline-5.2.tar.gz


URL=http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
TEXLIVE_INSTALL_PREFIX=/opt/texlive ./install-tl

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
