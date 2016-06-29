#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:install-tl-unx:null
#VER:readline:5.2

#REC:gs
#REC:x7lib
#REC:libxcb
#REC:epdfview
#REC:glu
#REC:python2
#REC:ruby
#REC:xorg-server


cd $SOURCE_DIR

URL=http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz

wget -nc ftp://ftp.gnu.org/gnu/readline/readline-5.2.tar.gz
wget -nc http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
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
echo "tl-installer=>`date`" | sudo tee -a $INSTALLED_LIST

