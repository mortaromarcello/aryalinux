#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="%DESCRIPTION%"
SECTION="general"
VERSION=1.10.0
NAME="python-modules#py2cairo"

#REQ:python2
#REQ:cairo


wget -nc http://cairographics.org/releases/py2cairo-1.10.0.tar.bz2


URL=http://cairographics.org/releases/py2cairo-1.10.0.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./waf configure --prefix=/usr &&
./waf build


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
./waf install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
