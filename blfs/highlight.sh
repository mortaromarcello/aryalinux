#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak Highlight is an utility thatbr3ak converts source code to formatted text with syntax highlighting.br3ak"
SECTION="general"
VERSION=3.32
NAME="highlight"

#REQ:boost
#REQ:lua
#OPT:doxygen


cd $SOURCE_DIR

URL=http://www.andre-simon.de/zip/highlight-3.32.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://www.andre-simon.de/zip/highlight-3.32.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/highlight/highlight-3.32.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/highlight/highlight-3.32.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/highlight/highlight-3.32.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/highlight/highlight-3.32.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/highlight/highlight-3.32.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
