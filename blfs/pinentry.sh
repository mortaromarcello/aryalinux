#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The PIN-Entry package contains abr3ak collection of simple PIN or pass-phrase entry dialogs which utilizebr3ak the Assuan protocol as described by the <a class="ulink" href="http://www.gnupg.org/aegypten/">�gypten project</a>. PIN-Entry programs are usually invoked by thebr3ak <span class="command"><strong>gpg-agent</strong> daemon, butbr3ak can be run from the command line as well. There are programs forbr3ak various text-based and GUI environments, including interfacesbr3ak designed for Ncurses (text-based),br3ak and for the common GTK andbr3ak Qt toolkits.br3ak
#SECTION:general

#REQ:libassuan
#REQ:libgpg-error
#OPT:emacs
#OPT:gcr
#OPT:gtk2
#OPT:gtk3
#OPT:libsecret
#OPT:qt5


#VER:pinentry:0.9.7


NAME="pinentry"

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pinentry/pinentry-0.9.7.tar.bz2 || wget -nc ftp://ftp.gnupg.org/gcrypt/pinentry/pinentry-0.9.7.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pinentry/pinentry-0.9.7.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pinentry/pinentry-0.9.7.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pinentry/pinentry-0.9.7.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pinentry/pinentry-0.9.7.tar.bz2


URL=ftp://ftp.gnupg.org/gcrypt/pinentry/pinentry-0.9.7.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
