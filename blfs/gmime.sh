#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GMime package contains a setbr3ak of utilities for parsing and creating messages using thebr3ak Multipurpose Internet Mail Extension (MIME) as defined by thebr3ak applicable RFCs. See the <a class="ulink" href="http://spruce.sourceforge.net/gmime/">GMime web site</a> for thebr3ak RFCs resourced. This is useful as it provides an API which adheresbr3ak to the MIME specification as closely as possible while alsobr3ak providing programmers with an extremely easy to use interface tobr3ak the API functions.br3ak
#SECTION:general

#REQ:glib2
#REQ:libgpg-error
#REC:gobject-introspection
#REC:vala
#OPT:docbook-utils
#OPT:gpgme
#OPT:gtk-doc


#VER:gmime:2.6.20


NAME="gmime"

wget -nc http://ftp.gnome.org/pub/gnome/sources/gmime/2.6/gmime-2.6.20.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gmime/gmime-2.6.20.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gmime/gmime-2.6.20.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gmime/gmime-2.6.20.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gmime/gmime-2.6.20.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gmime/gmime-2.6.20.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gmime/2.6/gmime-2.6.20.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gmime/2.6/gmime-2.6.20.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
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
