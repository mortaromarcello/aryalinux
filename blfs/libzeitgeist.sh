#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libzeitgeist package containsbr3ak a client library used to access and manage the Zeitgeist event logbr3ak from languages such as C and Vala. Zeitgeist is a service whichbr3ak logs the user's activities and events (files opened, websitesbr3ak visited, conversations hold with other people, etc.) and makes thebr3ak relevant information available to other applications.br3ak
#SECTION:general

#REQ:glib2
#OPT:gtk-doc


#VER:libzeitgeist:0.3.18


NAME="libzeitgeist"

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libzeitgeist/libzeitgeist-0.3.18.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libzeitgeist/libzeitgeist-0.3.18.tar.gz || wget -nc https://launchpad.net/libzeitgeist/0.3/0.3.18/+download/libzeitgeist-0.3.18.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libzeitgeist/libzeitgeist-0.3.18.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libzeitgeist/libzeitgeist-0.3.18.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libzeitgeist/libzeitgeist-0.3.18.tar.gz


URL=https://launchpad.net/libzeitgeist/0.3/0.3.18/+download/libzeitgeist-0.3.18.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

sed -i  "s|/doc/libzeitgeist|&-0.3.18|" Makefile.in &&

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
